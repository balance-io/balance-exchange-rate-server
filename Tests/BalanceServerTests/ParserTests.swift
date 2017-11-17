//
//  ParserTests.swift
//  BalanceServerTests
//
//  Created by Raimon Lapuente Ferran on 29/09/2017.
//

import XCTest
@testable import BalanceServerLib

class ParserTests: XCTestCase {
    
    var json: [String:AnyObject]!

    override func setUp() {
        super.setUp()
        self.json = [String:AnyObject]()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseFunctionNumberOfParsers() {
        //then
        XCTAssertEqual(ExchangeRateParsing.parseFunctions.count, ExchangeRateSource.all.count)
    }
    
    func testPoloniexParsingDoesntGiveError() {
        //given
        let poloniexData = TestHelpers.poloniexData
        
        //when
        let (_,error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNil(error)
    }
    
    func testPoloniexParsingThrowsErrorOnEmptyData() {
        //given
        let poloniexData = TestHelpers.emptyData
        
        //when
        let (_,error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testPoloniexParsingThrowsErrorOnWrongData() {
        //given
        let poloniexData = TestHelpers.wrongData
        
        //when
        let (_,error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testPoloniexParsingNumberOfObjects() {
        //given
        let poloniexData = TestHelpers.poloniexData
        
        //when
        let (exchangeRates,error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertEqual(exchangeRates.count, 101,(error?.errorDescription)!)
    }
    
    func testPoloniexParsingObjectProperties() {
        //given
        let poloniexData = TestHelpers.poloniexSimpleData
        
        //when
        let (exchangeRates,_) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.poloniex)
        XCTAssertEqual(exchangeRate.to, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.from, Currency.cryptoOther(code: "BCN"))
        XCTAssertEqual(exchangeRate.rate, 0.00000032) 
    }
    
    func testBitfinexxParsingDoesntGiveError() {
        //given
        let bitfinexData = TestHelpers.bitfinexData
        
        //when
        let (_,error) = ExchangeRateParsing.bitfinex(responseData: bitfinexData)
        
        //then
        XCTAssertNil(error)
    }
    
    func testBitfinexParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_,error) = ExchangeRateParsing.bitfinex(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testBitfinexParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_,error) = ExchangeRateParsing.bitfinex(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testBitfinexParsingNumberOfObjects() {
        //given
        let bitfinexData = TestHelpers.bitfinexData
        
        //when
        let (exchangeRates,error) = ExchangeRateParsing.bitfinex(responseData: bitfinexData)
        
        //then
        XCTAssertEqual(exchangeRates.count, 15,(error?.errorDescription)!)
    }
    
    func testBitfinexParsingObjectProperties() {
        //given
        let bitfinexData = TestHelpers.bitfinexSimpleData
        
        //when
        let (exchangeRates,_) = ExchangeRateParsing.bitfinex(responseData: bitfinexData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.bitfinex)
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.rate, 4187.1)
    }
    
    func testCoinbaseParsingDoesntGiveError() {
        //given
        let coinbaseData = TestHelpers.coinbaseData
        
        //when
        let (_,error) = ExchangeRateParsing.coinbaseGdax(responseData: coinbaseData)
        
        //then
        XCTAssertNil(error)
    }
    
    func testCoinbaseParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_,error) = ExchangeRateParsing.coinbaseGdax(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testCoinbaseParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_,error) = ExchangeRateParsing.coinbaseGdax(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testCoinbaseParsingNumberOfObjects() {
        //given
        let coinbaseData = TestHelpers.coinbaseData
        
        //when
        let (exchangeRates,error) = ExchangeRateParsing.coinbaseGdax(responseData: coinbaseData)
        
        //then
        XCTAssertEqual(exchangeRates.count, 3,(error?.errorDescription)!)
    }
    
    func testCoinbaseParsingObjectProperties() {
        //given
        let coinbaseData = TestHelpers.coinbaseSimpleData
        
        //when
        let (exchangeRates,_) = ExchangeRateParsing.coinbaseGdax(responseData: coinbaseData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.coinbaseGdax)
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.rate, 4167.99)
    }
    
    func testKrakenParsingDoesntGiveError() {
        //given
        let krakenData = TestHelpers.krakenData
        
        //when
        let (_,error) = ExchangeRateParsing.kraken(responseData: krakenData)
        
        //then
        XCTAssertNil(error)
    }
    
    func testKrakenParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_,error) = ExchangeRateParsing.kraken(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testKrakenParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_,error) = ExchangeRateParsing.kraken(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testKrakenParsingNumberOfObjects() {
        //given
        let krakenData = TestHelpers.krakenData
        
        //when
        let (exchangeRates,error) = ExchangeRateParsing.kraken(responseData: krakenData)
        
        //then
        XCTAssertEqual(exchangeRates.count, 17,(error?.errorDescription)!)
    }
    
    func testKrakenParsingObjectProperties() {
        //given
        let krakenData = TestHelpers.krakenSimpleData
        
        //when
        let (exchangeRates,_) = ExchangeRateParsing.kraken(responseData: krakenData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.kraken)
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum:.bch))
        XCTAssertEqual(exchangeRate.rate, 441.7)
    }
    
    func testKucoinParsingDoesntGiveError() {
        //given
        let kucoinData = TestHelpers.kucoinData
        
        //when
        let (_,error) = ExchangeRateParsing.kucoin(responseData: kucoinData)
        
        //then
        XCTAssertNil(error)
    }
    
    func testKucoinParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_,error) = ExchangeRateParsing.kucoin(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error, (error?.errorDescription)!)
    }
    
    func testKucoinParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_,error) = ExchangeRateParsing.kucoin(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error, (error?.errorDescription)!)
    }
    
    func testKucoinParsingNumberOfObjects() {
        //given
        let krakenData = TestHelpers.kucoinData
        
        //when
        let (exchangeRates,error) = ExchangeRateParsing.kucoin(responseData: krakenData)
        
        //then
        XCTAssertEqual(exchangeRates.count, 52, (error?.errorDescription)!)
    }
    
    func testKucoinParsingObjectProperties() {
        //given
        let krakenData = TestHelpers.kucoinSimpleData
        
        //when
        let (exchangeRates,_) = ExchangeRateParsing.kucoin(responseData: krakenData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.kucoin)
        XCTAssertEqual(exchangeRate.to, Currency.btc)
        XCTAssertEqual(exchangeRate.from, Currency.rawValue("KCS"))
        XCTAssertEqual(exchangeRate.rate, 9.1370000000000001e-05)
    }

    func testFixerParsingDoesntGiveError() {
        //given
        let fixerData = TestHelpers.fixerData
        
        //when
        let (_,error) = ExchangeRateParsing.fixer(responseData: fixerData)
        
        //then
        XCTAssertNil(error)
    }
    
    func testFixerParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_,error) = ExchangeRateParsing.fixer(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testFixerParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_,error) = ExchangeRateParsing.fixer(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error,(error?.errorDescription)!)
    }
    
    func testFixerParsingNumberOfObjects() {
        //given
        let fixerData = TestHelpers.fixerData
        
        //when
        let (exchangeRates,error) = ExchangeRateParsing.fixer(responseData: fixerData)
        
        //then
        XCTAssertEqual(exchangeRates.count, 31,(error?.errorDescription)!)
    }
    
    func testFixerParsingObjectProperties() {
        //given
        let fixerData = TestHelpers.fixerSimpleData
        
        //when
        let (exchangeRates,_) = ExchangeRateParsing.fixer(responseData: fixerData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.fixer)
        XCTAssertEqual(exchangeRate.to, Currency.gbp)
        XCTAssertEqual(exchangeRate.from, Currency.usd)
        XCTAssertEqual(exchangeRate.rate, 0.74406)
    }
}
