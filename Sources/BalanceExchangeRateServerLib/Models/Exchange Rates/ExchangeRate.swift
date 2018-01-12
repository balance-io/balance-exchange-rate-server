//
//  ExchangeRate.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/29/17.
//

import Foundation
import Dispatch
import PerfectLib
import PerfectThread
import PerfectMySQL

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

public struct ExchangeRates {
    // MARK: Get
    
    public static func latestExchangeRates() throws -> [String: Any] {
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
    
    public static func latestExchangeRates(forSource source: ExchangeRateSource, mysql: MySQL? = connectToMysql()) throws -> (Date, [ExchangeRate])? {
        guard let timestamp = try latestTimestamp(forSource: source) else {
            return nil
        }
        
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "SELECT * FROM \(ExchangeRateTable.current) WHERE timestamp = \"\(timestamp.mysqlFormatted)\" AND sourceId = \(source.source)"
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
    
    public static func latestTimestamp(forSource source: ExchangeRateSource, mysql: MySQL? = connectToMysql()) throws -> Date? {
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        let query = "SELECT MAX(timestamp) FROM \(ExchangeRateTable.current) WHERE sourceId = \(source.source)"
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
    
    public static func convert(amount: Double, from: Currency, to: Currency, source: ExchangeRateSource) -> Double? {
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
                    var fromRate: Double? = getRate(from: from, to: currency, source: source)
                    var toRate: Double? = getRate(from: currency, to: to, source: source)
                    for source in ExchangeRateSource.all {
                        if currency == from || currency == to {
                            continue
                        }
                        if fromRate == nil, let newfromRate = getRate(from: from, to: currency, source: source) {
                            fromRate = newfromRate
                        }
                        
                        if toRate == nil, let newtoRate = getRate(from: currency, to: to, source: source) {
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

    public static func directConvert(amount: Double, from: Currency, to: Currency, source: ExchangeRateSource) -> Double? {
        if let rate = getRate(from: from, to: to, source: source) {
            return amount * rate
        }
        return nil
    }
    
    public static func getRate(from: Currency, to: Currency, source: ExchangeRateSource) -> Double? {
        if let tryRates = try? latestExchangeRates(forSource: source), let (_, exchangeRates) = tryRates {
            // First check if the exact rate exists (either directly or reversed)
            if let rate = exchangeRates.rate(from: from, to: to) {
                return rate
            } else if let rate = exchangeRates.rate(from: to, to: from) {
                return (1.0 / rate)
            }
        }
        
        return nil
    }

    // MARK: Update
    
    public static func updateExchangeRates(sources: [ExchangeRateSource], session: DataSession = sharedSession) {
        // Call each API concurrently and store the rates
        let startTime = Date()
        let group = DispatchGroup()
        for source in sources {
            group.enter()
            ExchangeRates.updateRatesForExchange(source: source, startTime: startTime, session: session) { balError in
                if let balError = balError {
                    Log.error(message: "Error updating exchange rates for \(source): \(balError)")
                }
                group.leave()
            }
        }
        group.wait()
    }
    
    public static func updateRatesForExchange(source: ExchangeRateSource, startTime: Date, session: DataSession = sharedSession, completion: @escaping (BalanceError?) -> Void) {
        guard let parseFunction = ExchangeRateParsing.function(forSource: source) else {
            completion(.unknownError)
            return
        }
        
        let task = session.dataTask(with: source.request) { data, response, error in
            guard error == nil, let data = data else {
                Log.error(message: "updateExchangeRates for \(source): network error received or data is nil error: \(String(describing: error))")
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
    
    public static func insert(exchangeRates: [ExchangeRate], startTime: Date, tableName: String = ExchangeRateTable.current, mysql: MySQL? = connectToMysql()) -> BalanceError? {
        guard let mysql = mysql else {
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
