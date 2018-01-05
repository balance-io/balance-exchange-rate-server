//
//  CoinbaseHelper.swift
//  BalanceExchangeRateServerTests
//
//  Created by Raimon Lapuente Ferran on 03/10/2017.
//

import Foundation
import XCTest

extension TestHelpers {
    public static var coinbaseData: Data {
        let jsonData = TestHelpers.coinbaseApiResponse.data(using: .utf8)!
        return jsonData
    }
    
    public static var coinbaseSimpleData: Data {
        let jsonData = TestHelpers.coinbaseSimpleResponse.data(using: .utf8)!
        return jsonData
    }
    
    public static var coinbaseEurResponseData: Data {
        let jsonData = TestHelpers.coinbaseEurApiResponse.data(using: .utf8)!
        return jsonData
    }
    
    public static var coinbaseGbpResponseData: Data {
        let jsonData = TestHelpers.coinbaseGbpApiResponse.data(using: .utf8)!
        return jsonData
    }
    
    public static var coinbaseSimpleResponse = """
    {"data":[{"base":"BTC","currency":"USD","amount":"4167.99"}]}
    """
    
    public static var coinbaseApiResponse = """
    {"data":[{"base":"BTC","currency":"USD","amount":"4167.99"},{"base":"ETH","currency":"USD","amount":"292.16"},{"base":"LTC","currency":"USD","amount":"53.04"}],"warnings":[{"id":"missing_version","message":"Please supply API version (YYYY-MM-DD) as CB-VERSION header","url":"https://developers.coinbase.com/api#versioning"}]}
    """
    
    public static var coinbaseEurApiResponse = """
    {"data":[{"base":"BTC","currency":"EUR","amount":"12436.59"},{"base":"BCH","currency":"EUR","amount":"2185.20"},{"base":"ETH","currency":"EUR","amount":"722.65"},{"base":"LTC","currency":"EUR","amount":"208.02"}],"warnings":[{"id":"missing_version","message":"Please supply API version (YYYY-MM-DD) as CB-VERSION header","url":"https://developers.coinbase.com/api#versioning"}]}
    """
    
    public static var coinbaseGbpApiResponse = """
    {"data":[{"base":"BTC","currency":"GBP","amount":"11005.33"},{"base":"BCH","currency":"GBP","amount":"1939.52"},{"base":"ETH","currency":"GBP","amount":"640.62"},{"base":"LTC","currency":"GBP","amount":"184.10"}],"warnings":[{"id":"missing_version","message":"Please supply API version (YYYY-MM-DD) as CB-VERSION header","url":"https://developers.coinbase.com/api#versioning"}]}
    """
}
