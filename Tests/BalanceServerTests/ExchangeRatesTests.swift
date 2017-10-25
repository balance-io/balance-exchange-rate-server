//
//  ExchangeRatesTests.swift
//  BalanceServerTests
//
//  Created by Raimon Lapuente Ferran on 06/10/2017.
//

import Foundation
import XCTest
@testable import BalanceServerLib

class ExchangeRatesTests: XCTestCase {
    
    var mockSession: MockSession!
    var exchange: ExchangeRatesHandlers!
    
    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        ExchangeRatesHandlers.urlSession = mockSession
        exchange = ExchangeRatesHandlers()
        
        ExchangeRateTable.rotate()
        loadExhangeInfo()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        mockSession = nil
        exchange = nil
    }
    
    func testConvert() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allCrypto)
        
        //then
        XCTAssertNotNil(try exchangeRate.latestExchangeRates())
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
    
    func testConvertFiat() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allFiat)
        
        //then
        XCTAssertNotNil(try exchangeRate.latestExchangeRates(forSource: .fixer))
        let exchange = exchangeRate.convert(amount: 10.0, from: .usd, to: .eur, source: ExchangeRateSource.fixer)
        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), 849)
    }
    
    func testConvertCryptoPoloniex() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allCrypto)
        
        //then
        XCTAssertNotNil(try exchangeRate.latestExchangeRates(forSource: .poloniex))
        let exchange = exchangeRate.convert(amount: 10.0, from: .btc, to: .eth, source: ExchangeRateSource.poloniex)
//        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), ((1/0.07003471)*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    func testConvertCryptoBitfinex() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allCrypto)
        
        //then
        XCTAssertNotNil(try exchangeRate.latestExchangeRates(forSource: .bitfinex))
        let exchange = exchangeRate.convert(amount: 10.0, from: .eth, to: .usd, source: ExchangeRateSource.bitfinex)
//        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (293.5*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    func testConvertCryptoCoinbase() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allCrypto)
        
        //then
        XCTAssertNotNil(try exchangeRate.latestExchangeRates(forSource: .coinbaseGdax))
        let exchange = exchangeRate.convert(amount: 10.0, from: .ltc, to: .usd, source: ExchangeRateSource.coinbaseGdax)
        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (53.04*10.0).integerFixedCryptoDecimals())
    }
    
    func testConvertCryptoKraken() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.allCrypto)
        
        //then
        XCTAssertNotNil(try exchangeRate.latestExchangeRates(forSource: .kraken))
        let exchange = exchangeRate.convert(amount: 10.0, from: Currency.rawValue("BCH"), to: .usd, source: ExchangeRateSource.kraken)
//        XCTAssertEqual(exchange?.integerFixedCryptoDecimals(), (441.7*10.0).integerFixedCryptoDecimals())
        XCTAssertNotNil(exchange)
    }
    
    func testConvertCryptoDoubleTransformCryptoToOtherFiat() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.all)

        //then
        let exchange = exchangeRate.convert(amount: 10.0, from: Currency.rawValue("BCH"), to: .eur, source: .bitfinex)
//        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), ((443.99*10.0)*0.849).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    func testConvertCryptoLTCtoUSDinPoloniex() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.all)
        
        //then
        let exchange = exchangeRate.convert(amount: 10.0, from: .ltc, to: .usd, source: .poloniex)
//        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), (53.0*10.0).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    func testConvertCryptoUSDTtoUSDinKraken() {
        //when
        let exchangeRate = ExchangeRates()
        _ = exchangeRate.updateExchangeRates(session: mockSession, sources: ExchangeRateSource.all)
        
        //then
        let exchange = exchangeRate.convert(amount: 10.0, from: Currency.rawValue("USDT"), to: .usd, source: .kraken)
//        XCTAssertEqual(exchange?.integerFixedFiatDecimals(), (53.0*10.0).integerFixedFiatDecimals())
        XCTAssertNotNil(exchange)
    }
    
    func loadExhangeInfo() {
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
    }
}
