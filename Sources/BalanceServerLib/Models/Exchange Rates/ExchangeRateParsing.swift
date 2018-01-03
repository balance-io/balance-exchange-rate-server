//
//  ExchangeRateParsing.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/28/17.
//

import Foundation
import PerfectLib

public struct ExchangeRateParsing {
    public typealias ParseFunction = (Data) -> ([ExchangeRate], BalanceError?)
    public static let parseFunctions: [ExchangeRateSource: ParseFunction] = [.coinbaseGdax: coinbaseGdax,
                                                                             .coinbaseGdaxEur: coinbaseGdax,
                                                                             .coinbaseGdaxGbp: coinbaseGdax,
                                                                             .poloniex:     poloniex,
                                                                             .bitfinex:     bitfinex,
                                                                             .kraken:       kraken,
                                                                             .kucoin:       kucoin,
                                                                             .fixer:        fixer]
    
    public static func function(forSource source: ExchangeRateSource) -> ParseFunction? {
        return parseFunctions[source]
    }
    
    public static func coinbaseGdax(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional, let data = body["data"] as? [[String: String]] else {
            return ([], .jsonDecoding)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for dict in data {
            guard let base = dict["base"], let amount = dict["amount"], let rate = Double(amount) else {
                return ([], .jsonDecoding)
            }
            
            let fromCurrency = Currency.rawValue(base)
            let exchangeRate = ExchangeRate(source: .coinbaseGdax, from: fromCurrency, to: .usd, rate: rate)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func poloniex(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for (key, value) in body {
            guard let dict = value as? [String: Any], let last = dict["last"] as? String, let rate = Double(last) else {
                return ([], .jsonDecoding)
            }
            
            // Parse currencies
            let components = key.components(separatedBy: CharacterSet(charactersIn: "_"))
            guard components.count == 2 else {
                return ([], .jsonDecoding)
            }
            let fromCurrency = Currency.rawValue(components[1])
            let toCurrency = Currency.rawValue(components[0])
            
            let exchangeRate = ExchangeRate(source: .poloniex, from: fromCurrency, to: toCurrency, rate: rate)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func bitfinex(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [[Any]], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for array in body {
            guard array.count == 11, let symbol = array[0] as? String, symbol.count == 7 else {
                return ([], .jsonDecoding)
            }
            
            // Parse currency
            let currencyCode = symbol.substring(with: Range(1..<4))
            let fromCurrency = Currency.rawValue(currencyCode)
            
            // Parse price as double
            let lastPrice = array[7]
            var lastPriceDouble = lastPrice as? Double
            if let lastPrice = lastPrice as? Int {
                lastPriceDouble = Double(lastPrice)
            }
            guard let rate = lastPriceDouble else {
                return ([], .jsonDecoding)
            }
            
            let exchangeRate = ExchangeRate(source: .bitfinex, from: fromCurrency, to: .usd, rate: rate)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func kraken(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional, let result = body["result"] as? [String: Any] else {
            return ([], .jsonDecoding)
        }
        
        // Check for errors
        if let errors = body["error"] as? [Any], errors.count > 0 {
            Log.error(message: "Found error(s) in the response: \(errors)")
            return ([], .jsonDecoding)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for (key, value) in result {
            guard let dict = value as? [String: Any], let c = dict["c"] as? [String], c.count == 2, let rate = Double(c[0]) else {
                return ([], .jsonDecoding)
            }
            
            // Parse currencies (hard code the inconsistant ones)
            let fromCurrency: Currency
            let toCurrency: Currency
            switch key {
            case "BCHUSD":
                fromCurrency = Currency.rawValue("BCH")
                toCurrency = .usd
            case "DASHUSD":
                fromCurrency = Currency.rawValue("DASH")
                toCurrency = .usd
            case "EOSXBT":
                fromCurrency = Currency.rawValue("EOS")
                toCurrency = Currency.rawValue("XBT")
            case "GNOXBT":
                fromCurrency = Currency.rawValue("GNO")
                toCurrency = Currency.rawValue("XBT")
            default:
                // Usually every currency is 4 characters, optionally pre-padded with X if it's crypto or Z if it's fiat
                if key.count == 8 {
                    var fromCode = key.substring(to: 4)
                    if fromCode.hasPrefix("X") || fromCode.hasPrefix("Z") {
                        fromCode = fromCode.substring(from: 1)
                    }
                    fromCurrency = Currency.rawValue(fromCode)
                    
                    var toCode = key.substring(from: 4)
                    if toCode.hasPrefix("X") || toCode.hasPrefix("Z") {
                        toCode = toCode.substring(from: 1)
                    }
                    toCurrency = Currency.rawValue(toCode)
                } else {
                    Log.error(message: "Currency pair \(key) failed to decode")
                    return ([], .jsonDecoding)
                }
            }
            
            let exchangeRate = ExchangeRate(source: .kraken, from: fromCurrency, to: toCurrency, rate: rate)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func kucoin(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional, let data = body["data"] as? [[String: Any]] else {
            return ([], .jsonDecoding)
        }
        
        // Check for success
        guard let success = body["success"] as? Bool, success == true else {
            Log.error(message: "Success was false")
            return ([], .jsonDecoding)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for rateDict in data {
            guard let coinType = rateDict["coinType"] as? String, let coinTypePair = rateDict["coinTypePair"] as? String, let lastDealPrice = rateDict["lastDealPrice"] as? Double else {
                return ([], .jsonDecoding)
            }
            
            let from = Currency.rawValue(coinType)
            let to = Currency.rawValue(coinTypePair)
            let exchangeRate = ExchangeRate(source: .kucoin, from: from, to: to, rate: lastDealPrice)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func fixer(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional, let rates = body["rates"] as? [String: Double] else {
            return ([], .jsonDecoding)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for (key, value) in rates {
            let exchangeRate = ExchangeRate(source: .fixer, from: .usd, to: Currency.rawValue(key), rate: value)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
}
