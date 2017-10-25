//
//  ExchangeRate.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/29/17.
//

import Foundation
import MySQL
import PerfectLib
import PerfectThread

public struct ExchangeRate {
    let source: ExchangeRateSource
    let from: Currency
    let to: Currency
    let rate: Double
}

public extension Array where Element == ExchangeRate {
    public func contains(from: Currency, to: Currency) -> Bool {
        return self.contains(where: {$0.from == from && $0.to == to})
    }
    
    public func rate(from: Currency, to: Currency) -> Double? {
        if let index = self.index(where: {$0.from == from && $0.to == to}) {
            return self[index].rate
        }
        return nil
    }
}

protocol ExchangeHandlers {
    func latestExchangeRates() throws -> [String: Any]
}

class ExchangeRates: ExchangeHandlers {
    // MARK: Get
    
    public func latestExchangeRates() throws -> [String: Any] {
        var dict = [String: Any]()
        for source in ExchangeRateSource.all {
            if let (timestamp, exchangeRates) = try latestExchangeRates(forSource: source) {
                var sourceDict = [String: Any]()
                // Formatting the date to string here because Perfect's jsonEncodedString() doesn't support dates
                sourceDict["timestamp"] = timestamp.jsonFormatted
                
                var rates = [[String: Any]]()
                for exchangeRate in exchangeRates {
                    var rate = [String: Any]()
                    rate["from"] = exchangeRate.from.code
                    rate["to"] = exchangeRate.to.code
                    rate["rate"] = exchangeRate.rate
                    rates.append(rate)
                }
                sourceDict["rates"] = rates
                
                dict["\(source.rawValue)"] = sourceDict
            }
        }
        return dict
    }
    
    public func latestExchangeRates(forSource source: ExchangeRateSource) throws -> (Date, [ExchangeRate])? {
        guard let timestamp = try latestTimestamp(forSource: source) else {
            return nil
        }
        
        guard let mysql = connectToMysql() else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "SELECT * FROM \(ExchangeRateTable.current) WHERE timestamp = \"\(timestamp.mysqlFormatted)\" AND sourceId = \(source.rawValue)"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query), statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
        
        var dbError: BalanceError?
        let results = statement.results()
        var exchangeRates = [ExchangeRate]()
        _ = results.forEachRow { element in
            // If we've had a database error, skip all remaining rows
            guard dbError == nil else {
                return
            }
            
            // Check for the correct data
            guard element.count == 5, let sourceId = element[1] as? UInt16, let source = ExchangeRateSource(rawValue: Int(sourceId)), let fromCode = element[2] as? String, let toCode = element[3] as? String, let rate = element[4] as? Double else {
                dbError = .databaseError
                return
            }
            
            // Save the exchange rate
            let exchangeRate = ExchangeRate(source: source, from: Currency.rawValue(fromCode), to: Currency.rawValue(toCode), rate: rate)
            exchangeRates.append(exchangeRate)
        }
        
        if let dbError = dbError {
            throw dbError
        }
        
        guard exchangeRates.count > 0 else {
            return nil
        }
        
        return (timestamp, exchangeRates)
    }
    
    public func latestTimestamp(forSource source: ExchangeRateSource) throws -> Date? {
        guard let mysql = connectToMysql() else {
            throw BalanceError.databaseError
        }
        
        let query = "SELECT MAX(timestamp) FROM \(ExchangeRateTable.current) WHERE sourceId = \(source.rawValue)"
        if mysql.query(statement: query) {
            var date: Date? = nil
            if let results = mysql.storeResults(), let row = results.next(), let timestamp = row[0] {
                date = Date.from(mysqlFormatted: timestamp)
            }
            return date
        } else {
            throw BalanceError.databaseError
        }
    }
    
    // MARK: - Private -
    
    // MARK: Convert
    
    public func convert(amount: Double, from: Currency, to: Currency, source: ExchangeRateSource) -> Double? {
        var rate: Double?
        
        if let newRate = directConvert(amount: amount, from: from, to: to, source: source) {
            return newRate
        }
        for source in ExchangeRateSource.all {
            if let newRate = directConvert(amount: amount, from: from, to: to, source: source) {
                rate = newRate
            }
            if rate != nil {
                return rate!
            } else {
                //change currency and loop through all sources to get a connecting currency to use as middle point
                for currency in source.mainCurrencies {
                    var fromRate: Double? = directConvert(amount: amount, from: from, to: currency, source: source)
                    var toRate: Double? = directConvert(amount: amount, from: currency, to: to, source: source)
                    for source in ExchangeRateSource.all {
                        if currency == from || currency == to {
                            continue
                        }
                        if fromRate == nil, let newfromRate = directConvert(amount: amount, from: from, to: currency, source: source) {
                            fromRate = newfromRate
                        }
                        
                        if toRate == nil, let newtoRate = directConvert(amount: amount, from: currency, to: to, source: source) {
                            toRate = newtoRate
                        }
                        if fromRate != nil && toRate != nil {
                            return amount * fromRate! * toRate!
                        }
                    }
                }
            }
        }
        return nil
    }
    
    public func directConvert(amount: Double, from: Currency, to: Currency, source: ExchangeRateSource) -> Double? {
        
        Log.debug(message: "converting from \(from) to \(to) source \(source)")

        if let tryRates = try? latestExchangeRates(forSource: source), let (_, exchangeRates) = tryRates {
            // First check if the exact rate exists (either directly or reversed)
            if let rate = exchangeRates.rate(from: from, to: to) {
                Log.debug(message: "found direct conversion")
                return amount * rate
            } else if let rate = exchangeRates.rate(from: to, to: from) {
                Log.debug(message: "found direct reverse conversion")
                return amount * (1.0 / rate)
            }
        }

        return nil
    }

    // MARK: Update
    
    public func updateExchangeRates(session:URLSession, sources: [ExchangeRateSource]) {
        let startTime = Date()
        // Call each API and store the rates
        // TODO: Rewrite this to be concurrent
        for source in sources {
            let exchangeRates = ExchangeRates()
            let promise = Promise<Bool> { p in
                exchangeRates.updateRatesForExchange(session: session ,source: source, startTime: startTime) { balError in
                    if let balError = balError {
                        print("Error updating exchange rates for \(source): \(balError)")
                    }
                    p.set(true)
                }
            }
            
            do {
                _ = try promise.wait(seconds: 5.0)
            } catch {
                print("Error updating exchange rates for \(source): \(error)")
            }
        }
    }
    
    public func updateRatesForExchange(session: URLSession, source: ExchangeRateSource, startTime: Date, completion: @escaping (BalanceError?) -> Void) {
        guard let parseFunction = ExchangeRateParsing.function(forSource: source) else {
            completion(.unknownError)
            return
        }
        
        let task = session.dataTask(with: source.request) { data, response, error in
            guard error == nil, let data = data else {
                print("updateExchangeRates for \(source): network error received or data is nil error: \(String(describing: error))")
                completion(.networkError)
                return
            }
            
            // Parse the exchange rates
            let (rates, balError) = parseFunction(data)
            if let balError = balError {
                completion(balError)
                return
            }
            
            // Insert the exchange rates
            let dbError = self.insert(exchangeRates: rates, startTime: startTime)
            completion(dbError)
        }
        task.resume()
    }
    
    public func insert(exchangeRates: [ExchangeRate], startTime: Date, tableName: String = ExchangeRateTable.current) -> BalanceError? {
        guard let mysql = connectToMysql() else {
            return .databaseError
        }
        
        defer {
            mysql.close()
        }
        
        // Queries
        var queries = ["BEGIN"]
        for exchangeRate in exchangeRates {
            queries.append("INSERT INTO \(tableName) VALUES (\"\(startTime.mysqlFormatted)\", \"\(exchangeRate.source.rawValue)\", \"\(exchangeRate.from.code)\", \"\(exchangeRate.to.code)\", \(exchangeRate.rate))")
        }
        queries.append("COMMIT")
        
        for query in queries {
            guard mysql.query(statement: query) else {
                Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
                return .databaseError
            }
        }
        
        return nil
    }
}
