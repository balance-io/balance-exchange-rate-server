//
//  ExchangeRatesTests.swift
//  BalanceServerTests
//
//  Created by Raimon Lapuente Ferran on 06/10/2017.
//

import Foundation
import XCTest
@testable import BalanceServerLib

public class ExchangeRatesTests: XCTestCase {
    
    // required for running tests from `swift test` command
    public static var allTests : [(String, (ExchangeRatesTests) -> () throws -> Void)] {
        return [("testConvert", testConvert),
                ("testConvertFiat", testConvertFiat),
                ("testConvertCryptoPoloniex", testConvertCryptoPoloniex),
                ("testConvertCryptoBitfinex", testConvertCryptoBitfinex),
                ("testConvertCryptoCoinbase", testConvertCryptoCoinbase),
                ("testConvertCryptoKraken", testConvertCryptoKraken),
                ("testConvertCryptoKucoin", testConvertCryptoKucoin),
                ("testConvertCryptoDoubleTransformCryptoToOtherFiat", testConvertCryptoDoubleTransformCryptoToOtherFiat),
                ("testConvertCryptoLTCtoUSDinPoloniex", testConvertCryptoLTCtoUSDinPoloniex),
                ("testConvertCryptoUSDTtoUSDinKraken", testConvertCryptoUSDTtoUSDinKraken),
                ("testConvertCryptoRDNtoUSDinKucoin", testConvertCryptoRDNtoUSDinKucoin)]
    }
    
    private let mockSession = MockSession()
    
    override public func setUp() {
        super.setUp()
        ExchangeRateTable.rotate()
        loadExhangeInfo()
    }
    
    public func testConvert() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allCrypto, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates())
    }
    
    //this only work if we can flush the database (test execution order is not guaranteed)
//    func testConvertFixerWhenNoFixerIsCalledShouldBeNil() {
//        //when
//        let exchangeRate = ExchangeRates()
//        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allCrypto)
//
//        //then
//        XCTAssertNil(try exchangeRate.latestExchangeRates(forSource: .fixer))
//    }
//
//    func testConvertCryptoWhenNoCryptoIsCalledShouldBeNil() {
//        //when
//        let exchangeRate = ExchangeRates()
//        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allFiat)
//
//        //then
//        XCTAssertNil(try exchangeRate.latestExchangeRates(forSource: .poloniex))
//    }
    
    public func testConvertFiat() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allFiat, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates(forSource: .fixer))
        let exchange = ExchangeRates.convert(amount: 10.0, from: .usd, to: .eur, source: ExchangeRateSource.fixer)
        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), 849)
    }
    
    public func testConvertCryptoPoloniex() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allCrypto, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates(forSource: .poloniex))
        let exchange = ExchangeRates.convert(amount: 10.0, from: .btc, to: .eth, source: ExchangeRateSource.poloniex)
//        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), ((1/0.07003471)*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoBitfinex() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allCrypto, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates(forSource: .bitfinex))
        let exchange = ExchangeRates.convert(amount: 10.0, from: .eth, to: .usd, source: ExchangeRateSource.bitfinex)
//        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (293.5*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoCoinbase() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allCrypto, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates(forSource: .coinbaseGdax))
        let exchange = ExchangeRates.convert(amount: 10.0, from: .ltc, to: .usd, source: ExchangeRateSource.coinbaseGdax)
        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (53.04*10.0).integerFixedCryptoDecimals())
    }
    
    public func testConvertCryptoKraken() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allCrypto, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates(forSource: .kraken))
        let exchange = ExchangeRates.convert(amount: 10.0, from: Currency.rawValue("BCH"), to: .usd, source: ExchangeRateSource.kraken)
//        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (441.7*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoKucoin() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.allCrypto, session: mockSession)
        
        //then
        XCTAssertNotNil(try ExchangeRates.latestExchangeRates(forSource: .kucoin))
        let exchange = ExchangeRates.convert(amount: 10.0, from: Currency.rawValue("RDN"), to: .btc, source: ExchangeRateSource.kucoin)
        //        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (441.7*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoDoubleTransformCryptoToOtherFiat() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.all, session: mockSession)

        //then
        let exchange = ExchangeRates.convert(amount: 10.0, from: Currency.rawValue("BCH"), to: .eur, source: .bitfinex)
//        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), ((443.99*10.0)*0.849).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoLTCtoUSDinPoloniex() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.all, session: mockSession)
        
        //then
        let exchange = ExchangeRates.convert(amount: 10.0, from: .ltc, to: .usd, source: .poloniex)
//        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), (53.0*10.0).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoUSDTtoUSDinKraken() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.all, session: mockSession)
        
        //then
        let exchange = ExchangeRates.convert(amount: 10.0, from: Currency.rawValue("USDT"), to: .usd, source: .kraken)
//        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), (53.0*10.0).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    public func testConvertCryptoRDNtoUSDinKucoin() {
        //when
        _ = ExchangeRates.updateExchangeRates(sources: ExchangeRateSource.all, session: mockSession)
        
        //then
        let exchange = ExchangeRates.convert(amount: 10.0, from: Currency.rawValue("RDN"), to: .usd, source: .kucoin)
        //        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), (53.0*10.0).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    private func loadExhangeInfo() {
        let bitfinexData = TestHelpers.bitfinexData
        self.mockSession.mockResponses.append(MockSession.Response(urlPattern: "bitfinex", data: bitfinexData, statusCode: 200, headers: nil))
        
        let fixerData = TestHelpers.fixerData
        self.mockSession.mockResponses.append(MockSession.Response(urlPattern: "fixer", data: fixerData, statusCode: 200, headers: nil))
        
        let krakenData = TestHelpers.krakenData
        self.mockSession.mockResponses.append(MockSession.Response(urlPattern: "kraken", data: krakenData, statusCode: 200, headers: nil))
        
        let poloniexData = TestHelpers.poloniexData
        self.mockSession.mockResponses.append(MockSession.Response(urlPattern: "poloniex", data: poloniexData, statusCode: 200, headers: nil))
        
        let coinbaseData = TestHelpers.coinbaseData
        self.mockSession.mockResponses.append(MockSession.Response(urlPattern: "coinbase", data: coinbaseData, statusCode: 200, headers: nil))
        
        let kucoinData = TestHelpers.kucoinData
        self.mockSession.mockResponses.append(MockSession.Response(urlPattern: "kucoin", data: kucoinData, statusCode: 200, headers: nil))
    }
}
