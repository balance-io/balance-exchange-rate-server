//
//  CoinbaseHelper.swift
//  BalanceServerTests
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
    
    public static var coinbaseSimpleResponse = """
    {"data":[{"base":"BTC","currency":"USD","amount":"4167.99"}]}
    """
    
    public static var coinbaseApiResponse = """
    {"data":[{"base":"BTC","currency":"USD","amount":"4167.99"},{"base":"ETH","currency":"USD","amount":"292.16"},{"base":"LTC","currency":"USD","amount":"53.04"}],"warnings":[{"id":"missing_version","message":"Please supply API version (YYYY-MM-DD) as CB-VERSION header","url":"https://developers.coinbase.com/api#versioning"}]}
    """
}
