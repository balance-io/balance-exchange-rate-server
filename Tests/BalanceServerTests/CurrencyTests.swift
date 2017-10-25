//
//  CurrencyTests.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/18/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import XCTest
@testable import BalanceServerLib

class CurrencyTests: XCTestCase {
    
    // required for running tests from swift
    static var allTests : [(String, (CurrencyTests) -> () throws -> Void)] {
        return [("testBitcoinEquality", testBitcoinEquality)]
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBitcoinEquality() {
        XCTAssert(Currency.btc == Currency.btc)
        XCTAssert(Currency.rawValue("XBT") == Currency.btc)
        XCTAssert(Currency.btc == Currency.rawValue("XBT"))
        XCTAssert(Currency.rawValue("XBT") == Currency.rawValue("XBT"))
    }
    
    
    func testNumberOfDecimalsForDollar() {
        //given
        let currency = Currency.rawValue("USD")
        
        //then
        XCTAssertEqual(currency.decimals, 2)
    }
    
    func testNumberOfDecimalsForPound() {
        //given
        let currency = Currency.rawValue("GBP")

        //then
        XCTAssertEqual(currency.decimals, 2)
    }

    func testNumberOfDecimalsForBTC() {
        //given
        let currency = Currency.rawValue("BTC")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }

    func testNumberOfDecimalsForEther() {
        //given
        let currency = Currency.rawValue("ETH")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }

    func testNumberOfDecimalsForOtherCryptoSC() {
        //given
        let currency = Currency.rawValue("SC")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }

    func testNumberOfDecimalsForOtherCryptoXRP() {
        //given
        let currency = Currency.rawValue("XRP")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }
    
    func testTryCoin() {
        //given
        let currency = Currency.rawValue("TRY")
        
        //then
        XCTAssertEqual(currency.code, FiatCurrency.`try`.code)
        XCTAssertEqual(currency.symbol, FiatCurrency.`try`.symbol)
        XCTAssertEqual(currency.decimals, FiatCurrency.`try`.decimals)
    }

}
