//
//  CurrencyTests.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/18/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import XCTest
@testable import BalanceExchangeRateServerLib

public class CurrencyTests: XCTestCase {
    
    // required for running tests from `swift test` command
    public static var allTests : [(String, (CurrencyTests) -> () throws -> Void)] {
        return [("testBitcoinEquality", testBitcoinEquality),
                ("testNumberOfDecimalsForDollar", testNumberOfDecimalsForDollar),
                ("testNumberOfDecimalsForPound", testNumberOfDecimalsForPound),
                ("testNumberOfDecimalsForBTC", testNumberOfDecimalsForBTC),
                ("testNumberOfDecimalsForBTC", testNumberOfDecimalsForEther),
                ("testNumberOfDecimalsForOtherCryptoSC", testNumberOfDecimalsForOtherCryptoSC),
                ("testNumberOfDecimalsForOtherCryptoXRP", testNumberOfDecimalsForOtherCryptoXRP),
                ("testTryCoin", testTryCoin)]
    }
    
    public func testBitcoinEquality() {
        XCTAssert(Currency.btc == Currency.btc)
        XCTAssert(Currency.rawValue("XBT") == Currency.btc)
        XCTAssert(Currency.btc == Currency.rawValue("XBT"))
        XCTAssert(Currency.rawValue("XBT") == Currency.rawValue("XBT"))
    }
    
    
    public func testNumberOfDecimalsForDollar() {
        //given
        let currency = Currency.rawValue("USD")
        
        //then
        XCTAssertEqual(currency.decimals, 2)
    }
    
    public func testNumberOfDecimalsForPound() {
        //given
        let currency = Currency.rawValue("GBP")

        //then
        XCTAssertEqual(currency.decimals, 2)
    }

    public func testNumberOfDecimalsForBTC() {
        //given
        let currency = Currency.rawValue("BTC")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }

    public func testNumberOfDecimalsForEther() {
        //given
        let currency = Currency.rawValue("ETH")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }

    public func testNumberOfDecimalsForOtherCryptoSC() {
        //given
        let currency = Currency.rawValue("SC")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }

    public func testNumberOfDecimalsForOtherCryptoXRP() {
        //given
        let currency = Currency.rawValue("XRP")

        //then
        XCTAssertEqual(currency.decimals, 8)
    }
    
    public func testTryCoin() {
        //given
        let currency = Currency.rawValue("TRY")
        
        //then
        XCTAssertEqual(currency.code, FiatCurrency.`try`.code)
        XCTAssertEqual(currency.symbol, FiatCurrency.`try`.symbol)
        XCTAssertEqual(currency.decimals, FiatCurrency.`try`.decimals)
    }

}
