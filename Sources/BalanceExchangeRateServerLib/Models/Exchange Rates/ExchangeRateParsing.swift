//
//  ExchangeRateParsing.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/28/17.
//

import Foundation
import PerfectLib

public struct ExchangeRateParsing {
    public typealias ParseFunction = (Data) -> ([ExchangeRate], BalanceError?)
    public static let parseFunctions: [ExchangeRateSource: ParseFunction] = [ // Crypto
                                                                             .coinbaseGdax:    coinbaseGdax,
                                                                             .coinbaseGdaxEur: coinbaseGdax,
                                                                             .coinbaseGdaxGbp: coinbaseGdax,
                                                                             .poloniex:        poloniex,
                                                                             .bitfinex:        bitfinex,
                                                                             .kraken:          kraken,
                                                                             .kucoin:          kucoin,
                                                                             .hitbtc:          hitbtc,
                                                                             .binance:         binance,
                                                                             .bittrex:         bittrex,
                                                                              // Fiat
                                                                             .fixer:           fixer,
                                                                             .currencylayer:   currencylayer]
    
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
            guard let base = dict["base"], let to = dict["currency"], let amount = dict["amount"], let rate = Double(amount) else {
                return ([], .unexpectedData)
            }
            
            let fromCurrency = Currency.rawValue(base)
            let toCurrency = Currency.rawValue(to)
            let exchangeRate = ExchangeRate(source: .coinbaseGdax, from: fromCurrency, to: toCurrency, rate: rate)
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
                return ([], .unexpectedData)
            }
            
            // Parse currencies
            let components = key.components(separatedBy: CharacterSet(charactersIn: "_"))
            guard components.count == 2 else {
                return ([], .unexpectedData)
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
                return ([], .unexpectedData)
            }
            
            // Parse currency
            let fromCurrencyCode = symbol.substring(with: Range(1..<4))
            let fromCurrency = Currency.rawValue(fromCurrencyCode)
            let toCurrencyCode = symbol.substring(from: 4)
            let toCurrency = Currency.rawValue(toCurrencyCode)
            
            // Parse price as double
            let lastPrice = array[7]
            var lastPriceDouble = lastPrice as? Double
            if let lastPrice = lastPrice as? Int {
                lastPriceDouble = Double(lastPrice)
            }
            guard let rate = lastPriceDouble else {
                return ([], .unexpectedData)
            }
            
            let exchangeRate = ExchangeRate(source: .bitfinex, from: fromCurrency, to: toCurrency, rate: rate)
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
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for (key, value) in result {
            guard let dict = value as? [String: Any], let c = dict["c"] as? [String], c.count == 2, let rate = Double(c[0]) else {
                return ([], .unexpectedData)
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
                    return ([], .unexpectedData)
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
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for rateDict in data {
            guard let coinType = rateDict["coinType"] as? String, let coinTypePair = rateDict["coinTypePair"] as? String, let lastDealPrice = rateDict["lastDealPrice"] as? Double else {
                return ([], .unexpectedData)
            }
            
            let from = Currency.rawValue(coinType)
            let to = Currency.rawValue(coinTypePair)
            let exchangeRate = ExchangeRate(source: .kucoin, from: from, to: to, rate: lastDealPrice)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func hitbtc(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [[String: Any]], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Check for success
        guard body.count > 0 else {
            Log.error(message: "Did not return any prices")
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for rateDict in body {
            // Sometimes the rate is not actually set yet, so continue rather than returning an error here
            guard let lastString = rateDict["last"] as? String, let last = Double(lastString), let symbol = rateDict["symbol"] as? String else {
                continue
            }
            
            guard symbol.count > 3 else {
                continue
            }
            
            // Parse currency
            let possibleToCurrencyCodes = ["USD", "BTC", "ETH"]
            let toCode = symbol.substring(with: Range(symbol.count - 3..<symbol.count))
            guard possibleToCurrencyCodes.contains(toCode) else {
                continue
            }
            
            let fromCode = symbol.substring(with: Range(0..<symbol.count - 3))
            let fromCurrency = Currency.rawValue(fromCode)
            let toCurrency = Currency.rawValue(toCode)
            let exchangeRate = ExchangeRate(source: .hitbtc, from: fromCurrency, to: toCurrency, rate: last)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func binance(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [[String: Any]], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Check for success
        guard body.count > 0 else {
            Log.error(message: "Did not return any prices")
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for rateDict in body {
            guard let priceString = rateDict["price"] as? String, let price = Double(priceString), let symbol = rateDict["symbol"] as? String else {
                return ([], .unexpectedData)
            }
            
            guard symbol.count > 3 else {
                continue
            }
            
            // Parse currency (ignoring USDT prices)
            let possibleToCurrencyCodes = ["BTC", "ETH", "BNB"]
            let toCode = symbol.substring(with: Range(symbol.count - 3..<symbol.count))
            guard possibleToCurrencyCodes.contains(toCode) else {
                continue
            }
            
            let fromCode = symbol.substring(with: Range(0..<symbol.count - 3))
            let fromCurrency = Currency.rawValue(fromCode)
            let toCurrency = Currency.rawValue(toCode)
            let exchangeRate = ExchangeRate(source: .binance, from: fromCurrency, to: toCurrency, rate: price)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    // Fixes the special case in Bittrex where they incorrectly use the BCC ticker symbol
    // for BCH (Bitcoin Cash). BCC is already the symbol of Bitconnect so we can't just make
    // them equivalent in the Currency enum and everyone else uses BCH, so we need to save
    // BCC from Bittrex as BCH for it to work correctly.
    public static func bittrexFixCurrencyCode(_ currencyCode: String) -> String {
        if currencyCode == "BCC" {
            return "BCH"
        }
        return currencyCode
    }
    
    public static func bittrex(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Check that the exchange rates are there
        guard let result = body["result"] as? [[String: Any]] else {
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for rateDict in result {
            guard let marketName = rateDict["MarketName"] as? String, let last = rateDict["Last"] as? Double else {
                return ([], .unexpectedData)
            }
            
            // Parse currency (ignoring USDT prices)
            let codes = marketName.components(separatedBy: "-")
            guard codes.count == 2 else {
                return ([], .unexpectedData)
            }
            
            let fromCode = bittrexFixCurrencyCode(codes[1])
            let toCode = bittrexFixCurrencyCode(codes[0])
            let from = Currency.rawValue(fromCode)
            let to = Currency.rawValue(toCode)
            
            let exchangeRate = ExchangeRate(source: .bittrex, from: from, to: to, rate: last)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func fixer(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Check that the exchange rates are there
        guard let rates = body["rates"] as? [String: Double] else {
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for (key, value) in rates {
            let exchangeRate = ExchangeRate(source: .fixer, from: .usd, to: Currency.rawValue(key), rate: value)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
    
    public static func currencylayer(responseData: Data) -> ([ExchangeRate], BalanceError?) {
        let responseString = String(data: responseData, encoding: .utf8)
        
        // Verify the response is correct
        guard let bodyOptional = try? responseString?.jsonDecode() as? [String: Any], let body = bodyOptional else {
            return ([], .jsonDecoding)
        }
        
        // Check that the exchange rates are there
        guard let rates = body["quotes"] as? [String: Any] else {
            return ([], .unexpectedData)
        }
        
        // Parse the exchange rates
        var exchangeRates = [ExchangeRate]()
        for (key, value) in rates {
            // Convert the value to a Double (some are Ints)
            var valueDouble = value as? Double
            if valueDouble == nil, let valueInt = value as? Int {
                valueDouble = Double(valueInt)
            }
            
            guard key.count == 6, let rate = valueDouble else {
                continue
            }
            
            let fromCode = key.substring(to: 3)
            let fromCurrency = Currency.rawValue(fromCode)
            let toCode = key.substring(from: 3)
            let toCurrency = Currency.rawValue(toCode)
            
            let exchangeRate = ExchangeRate(source: .currencylayer, from: fromCurrency, to: toCurrency, rate: rate)
            exchangeRates.append(exchangeRate)
        }
        
        return (exchangeRates, nil)
    }
}
