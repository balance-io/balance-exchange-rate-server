//
//  ExchangeRateSource.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/28/17.
//

import Foundation

public enum ExchangeRateSource: Int {
    // Crypto
    case coinbaseGdax = 1
    case poloniex     = 2
    case bitfinex     = 3
    case kraken       = 4
    case kucoin       = 5
    case hitbtc       = 6
    case binance      = 7
    case coinbaseGdaxEur = 8
    case coinbaseGdaxGbp = 9
    
    // Fiat
    case fixer         = 10001
    case currencylayer = 10002
    
    public var source: Int {
        switch self {
        case .coinbaseGdax, .coinbaseGdaxEur, .coinbaseGdaxGbp: return 1
        case .poloniex:      return 2
        case .bitfinex:      return 3
        case .kraken:        return 4
        case .kucoin:        return 5
        case .hitbtc:        return 6
        case .binance:       return 7
            
        case .fixer:         return 10001
        case .currencylayer: return 10002
        }
    }
    
    public var url: URL {
        switch self {
        // Crypto
        case .coinbaseGdax:
            return URL(string: "https://api.coinbase.com/v2/prices/usd/spot")!
        case .coinbaseGdaxEur:
            return URL(string: "https://api.coinbase.com/v2/prices/eur/spot")!
        case .coinbaseGdaxGbp:
            return URL(string: "https://api.coinbase.com/v2/prices/gbp/spot")!
        case .poloniex:
            return URL(string: "https://poloniex.com/public?command=returnTicker")!
        case .bitfinex:
            // TODO: Call https://api.bitfinex.com/v1/symbols API to get the current symbols\instead of updating manually
            return URL(string: "https://api.bitfinex.com/v2/tickers?symbols=tBTCUSD,tLTCUSD,tLTCBTC,tETHUSD,tETHBTC,tETCBTC,tETCUSD,tRRTUSD,tRRTBTC,tZECUSD,tZECBTC,tXMRUSD,tXMRBTC,tDSHUSD,tDSHBTC,tBCCBTC,tBCUBTC,tBCCUSD,tBCUUSD,tBTCEUR,tXRPUSD,tXRPBTC,tIOTUSD,tIOTBTC,tIOTETH,tEOSUSD,tEOSBTC,tEOSETH,tSANUSD,tSANBTC,tSANETH,tOMGUSD,tOMGBTC,tOMGETH,tBCHUSD,tBCHBTC,tBCHETH,tNEOUSD,tNEOBTC,tNEOETH,tETPUSD,tETPBTC,tETPETH,tQTMUSD,tQTMBTC,tQTMETH,tBT1USD,tBT2USD,tBT1BTC,tBT2BTC,tAVTUSD,tAVTBTC,tAVTETH,tEDOUSD,tEDOBTC,tEDOETH,tBTGUSD,tBTGBTC,tDATUSD,tDATBTC,tDATETH,tQSHUSD,tQSHBTC,tQSHETH,tYYWUSD,tYYWBTC,tYYWETH")!
        case .kraken:
            // TODO: Call https://api.kraken.com/0/public/AssetPairs API to get the current asset pairs instead of updating manually
            return URL(string: "https://api.kraken.com/0/public/Ticker?pair=BCHUSD,DASHUSD,XETCZUSD,XETHZUSD,XLTCZUSD,XXBTZUSD,XXMRZUSD,XXRPZUSD,XZECZUSD,EOSXBT,GNOXBT,XICNXXBT,XMLNXXBT,XREPXXBT,XXDGXXBT,XXLMXXBT,XXMRXXBT")!
        case .kucoin:
            return URL(string: "https://api.kucoin.com/v1/open/tick")!
        case .hitbtc:
            return URL(string: "https://api.hitbtc.com/api/2/public/ticker")!
        case .binance:
            return URL(string: "https://api.binance.com/api/v1/ticker/allPrices")!
        
        // Fiat
        case .fixer:
            return URL(string: "http://api.fixer.io/latest?base=USD")!
        case .currencylayer:
            return URL(string: "https://www.apilayer.net/api/live?access_key=\(Config.CurrencyLayer.accessKey)")!
        }
    }
    
    public var headers: [String: String] {
        switch self {
        case .coinbaseGdax:
            return ["CB-VERSION": "2017-05-19"]
        default:
            return [:]
        }
    }
    
    public var httpMethod: String {
        return "GET"
    }
    
    public var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        return request
    }
    
    // These are the currencies that values are stored in for this exchange (i.e. Poloniex only has BTC and ETC, but not fiat currencies)
    public var mainCurrencies: [Currency] {
        switch self {
        default: return [.btc, .eth, .usd]
        }
    }
    
    public static var allCrypto: [ExchangeRateSource] {
        return [coinbaseGdax, coinbaseGdaxEur, coinbaseGdaxGbp, .poloniex, .bitfinex, .kraken, .kucoin, .hitbtc, .binance]
    }
    
    public static var allFiat: [ExchangeRateSource] {
        return [.fixer, .currencylayer]
    }
    
    public static var all: [ExchangeRateSource] {
        return allCrypto + allFiat
    }
}
