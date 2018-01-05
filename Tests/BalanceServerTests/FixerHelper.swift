//
//  FixerHelper.swift
//  BalanceExchangeRateServerTests
//
//  Created by Raimon Lapuente Ferran on 03/10/2017.
//

import Foundation
import XCTest

extension TestHelpers {
    
    public static var fixerSimpleData: Data {
        let jsonData = TestHelpers.fixerSimpleResponse.data(using: .utf8)!
        return jsonData
    }
    
    public static var fixerData: Data {
        let jsonData = TestHelpers.fixerResponse.data(using: .utf8)!
        return jsonData
    }
    
    public static var fixerSimpleResponse = """
    {
        "base": "USD",
        "date": "2017-09-28",
        "rates": {
            "GBP": 0.74406
        }
    }
    """
    
    public static var fixerResponse = """
    {
        "base": "USD",
        "date": "2017-09-28",
        "rates": {
            "AUD": 1.2781,
            "BGN": 1.6606,
            "BRL": 3.1825,
            "CAD": 1.2467,
            "CHF": 0.973,
            "CNY": 6.6595,
            "CZK": 22.11,
            "DKK": 6.317,
            "GBP": 0.74406,
            "HKD": 7.8092,
            "HRK": 6.3657,
            "HUF": 264.1,
            "IDR": 13493.0,
            "ILS": 3.5216,
            "INR": 65.474,
            "JPY": 112.55,
            "KRW": 1146.4,
            "MXN": 18.166,
            "MYR": 4.2315,
            "NOK": 7.9449,
            "NZD": 1.3893,
            "PHP": 50.941,
            "PLN": 3.6612,
            "RON": 3.9058,
            "RUB": 58.062,
            "SEK": 8.1338,
            "SGD": 1.3593,
            "THB": 33.39,
            "TRY": 3.5655,
            "ZAR": 13.516,
            "EUR": 0.84904
        }
    }
    """
}
