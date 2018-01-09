//
//  ExchangeRatesHandlers.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/16/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL

// NOTE: Currently we are standardising all rates possible to USD then use the fiat exchange rate to get other fiat currencies.
// Most exchanges will directly return a USD rate. Poloniex does not return any values in USD and Kraken only returns some. So
// in cases like those, we store the value directly (i.e. for Poloniex ETH price we store in BTC) then convert to USD using a
// standard source, i.e. Coinbase/GDAX, then on to other fiat currencies as needed. We'll see if we need more precision in the future.
public struct ExchangeRatesHandlers {
    public static let routes = [["method": "get", "uri": "/exchangeRates", "handler": exchangeRatesHandler],
                                ["method": "get", "uri": "/exchangeRates/convert", "handler": convertHandler]]
    
    fileprivate static let exchangeRatesKey = "exchangeRates"
    
    // MARK: - Handlers -
    
    public static func exchangeRatesHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            do {
                let dict = try ExchangeRates.latestExchangeRates()
                sendSuccessJsonResponse(dict: dict, response: response)
            } catch {
                let returnError = error as? BalanceError ?? .networkError
                sendErrorJsonResponse(error: returnError, response: response)
            }
        }
    }
    
    public static func convertHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            guard let amountString = request.param(name: "amount"),
                  let amount = Double(amountString),
                  let fromString = request.param(name: "from"),
                  let toString = request.param(name: "to"),
                  let sourceId = request.param(name: "sourceId"),
                  let source = ExchangeRateSource(rawValue: Int(sourceId) ?? 0) else {
                    sendErrorJsonResponse(error: .invalidInputData, response: response)
                    return
            }
            
            let from = Currency.rawValue(fromString)
            let to = Currency.rawValue(toString)
            let value = ExchangeRates.convert(amount: amount, from: from, to: to, source: source)
            
            guard let returnValue = value else {
                sendErrorJsonResponse(error: .noData, response: response)
                return
            }
        
            sendSuccessJsonResponse(dict: ["value": returnValue.description], response: response)
        }
    }
}
