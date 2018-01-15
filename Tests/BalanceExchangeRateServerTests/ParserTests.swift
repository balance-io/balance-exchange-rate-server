//
//  ParserTests.swift
//  BalanceExchangeRateServerTests
//
//  Created by Raimon Lapuente Ferran on 29/09/2017.
//

import XCTest
@testable import BalanceExchangeRateServerLib

public class ParserTests: XCTestCase {
    
//    // required for running tests from `swift test` command
//    public static var allTests : [(String, (ParserTests) -> () throws -> Void)] {
//        return [("testParseFunctionNumberOfParsers", testParseFunctionNumberOfParsers),
//                
//                ("testPoloniexParsingDoesntGiveError", testPoloniexParsingDoesntGiveError),
//                ("testPoloniexParsingThrowsErrorOnEmptyData", testPoloniexParsingThrowsErrorOnEmptyData),
//                ("testPoloniexParsingThrowsErrorOnWrongData", testPoloniexParsingThrowsErrorOnWrongData),
//                ("testPoloniexParsingNumberOfObjects", testPoloniexParsingNumberOfObjects),
//                ("testPoloniexParsingObjectProperties", testPoloniexParsingObjectProperties),
//                
//                ("testBitfinexxParsingDoesntGiveError", testBitfinexxParsingDoesntGiveError),
//                ("testBitfinexParsingThrowsErrorOnEmptyData", testBitfinexParsingThrowsErrorOnEmptyData),
//                ("testBitfinexParsingThrowsErrorOnWrongData", testBitfinexParsingThrowsErrorOnWrongData),
//                ("testBitfinexParsingNumberOfObjects", testBitfinexParsingNumberOfObjects),
//                ("testBitfinexParsingObjectProperties", testBitfinexParsingObjectProperties),
//                
//                ("testCoinbaseParsingDoesntGiveError", testCoinbaseParsingDoesntGiveError),
//                ("testCoinbaseParsingThrowsErrorOnEmptyData", testCoinbaseParsingThrowsErrorOnEmptyData),
//                ("testCoinbaseParsingThrowsErrorOnWrongData", testCoinbaseParsingThrowsErrorOnWrongData),
//                ("testCoinbaseParsingNumberOfObjects", testCoinbaseParsingNumberOfObjects),
//                ("testCoinbaseParsingObjectProperties", testCoinbaseParsingObjectProperties),
//                
//                ("testKrakenParsingDoesntGiveError", testKrakenParsingDoesntGiveError),
//                ("testKrakenParsingThrowsErrorOnEmptyData", testKrakenParsingThrowsErrorOnEmptyData),
//                ("testKrakenParsingThrowsErrorOnWrongData", testKrakenParsingThrowsErrorOnWrongData),
//                ("testKrakenParsingNumberOfObjects", testKrakenParsingNumberOfObjects),
//                ("testKrakenParsingObjectProperties", testKrakenParsingObjectProperties),
//                
//                ("testKucoinParsingDoesntGiveError", testKucoinParsingDoesntGiveError),
//                ("testKucoinParsingThrowsErrorOnEmptyData", testKucoinParsingThrowsErrorOnEmptyData),
//                ("testKucoinParsingThrowsErrorOnWrongData", testKucoinParsingThrowsErrorOnWrongData),
//                ("testKucoinParsingNumberOfObjects", testKucoinParsingNumberOfObjects),
//                ("testKucoinParsingObjectProperties", testKucoinParsingObjectProperties),
//                
//                ("testHitbtcParsingDoesntGiveError", testHitbtcParsingDoesntGiveError),
//                ("testHitbtcParsingThrowsErrorOnEmptyData", testHitbtcParsingThrowsErrorOnEmptyData),
//                ("testHitbtcParsingThrowsErrorOnWrongData", testHitbtcParsingThrowsErrorOnWrongData),
//                ("testHitbtcParsingNumberOfObjects", testHitbtcParsingNumberOfObjects),
//                ("testHitbtcParsingObjectProperties", testHitbtcParsingObjectProperties),
//                
//                ("testBinanceParsingDoesntGiveError", testBinanceParsingDoesntGiveError),
//                ("testBinanceParsingThrowsErrorOnEmptyData", testBinanceParsingThrowsErrorOnEmptyData),
//                ("testBinanceParsingThrowsErrorOnWrongData", testBinanceParsingThrowsErrorOnWrongData),
//                ("testBinanceParsingNumberOfObjects", testBinanceParsingNumberOfObjects),
//                ("testBinanceParsingObjectProperties", testBinanceParsingObjectProperties),
//                
//                ("testBittrexParsingDoesntGiveError", testBittrexParsingDoesntGiveError),
//                ("testBittrexParsingThrowsErrorOnEmptyData", testBittrexParsingThrowsErrorOnEmptyData),
//                ("testBittrexParsingThrowsErrorOnWrongData", testBittrexParsingThrowsErrorOnWrongData),
//                ("testBittrexParsingNumberOfObjects", testBittrexParsingNumberOfObjects),
//                ("testBittrexParsingObjectProperties", testBittrexParsingObjectProperties),
//                
//                ("testFixerParsingDoesntGiveError", testFixerParsingDoesntGiveError),
//                ("testFixerParsingThrowsErrorOnEmptyData", testFixerParsingThrowsErrorOnEmptyData),
//                ("testFixerParsingThrowsErrorOnWrongData", testFixerParsingThrowsErrorOnWrongData),
//                ("testFixerParsingNumberOfObjects", testFixerParsingNumberOfObjects),
//                ("testFixerParsingObjectProperties", testFixerParsingObjectProperties),
//                
//                ("testCurrencylayerParsingDoesntGiveError", testCurrencylayerParsingDoesntGiveError),
//                ("testCurrencylayerParsingThrowsErrorOnEmptyData", testCurrencylayerParsingThrowsErrorOnEmptyData),
//                ("testCurrencylayerParsingThrowsErrorOnWrongData", testCurrencylayerParsingThrowsErrorOnWrongData),
//                ("testCurrencylayerParsingNumberOfObjects", testCurrencylayerParsingNumberOfObjects),
//                ("testCurrencylayerParsingObjectProperties", testCurrencylayerParsingObjectProperties)
//        ]
//    }
    
    public func testParseFunctionNumberOfParsers() {
        //then
        XCTAssertEqual(ExchangeRateParsing.parseFunctions.count, ExchangeRateSource.all.count)
    }
    
    public func testPoloniexParsingDoesntGiveError() {
        //given
        let poloniexData = TestHelpers.poloniexData
        
        //when
        let (_, error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testPoloniexParsingThrowsErrorOnEmptyData() {
        //given
        let poloniexData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testPoloniexParsingThrowsErrorOnWrongData() {
        //given
        let poloniexData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testPoloniexParsingNumberOfObjects() {
        //given
        let poloniexData = TestHelpers.poloniexData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 101)
    }
    
    public func testPoloniexParsingObjectProperties() {
        //given
        let poloniexData = TestHelpers.poloniexSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.poloniex(responseData: poloniexData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.poloniex)
        XCTAssertEqual(exchangeRate.from, Currency.cryptoOther(code: "BCN"))
        XCTAssertEqual(exchangeRate.to, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.rate, 0.00000032)
    }
    
    public func testBitfinexxParsingDoesntGiveError() {
        //given
        let bitfinexData = TestHelpers.bitfinexData
        
        //when
        let (_, error) = ExchangeRateParsing.bitfinex(responseData: bitfinexData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testBitfinexParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.bitfinex(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testBitfinexParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.bitfinex(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testBitfinexParsingNumberOfObjects() {
        //given
        let bitfinexData = TestHelpers.bitfinexData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.bitfinex(responseData: bitfinexData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 67)
    }
    
    public func testBitfinexParsingObjectProperties() {
        //given
        let bitfinexData = TestHelpers.bitfinexSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.bitfinex(responseData: bitfinexData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.bitfinex)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.rate, 4187.1)
    }
    
    public func testCoinbaseParsingDoesntGiveError() {
        //given
        let coinbaseData = TestHelpers.coinbaseData
        
        //when
        let (_, error) = ExchangeRateParsing.coinbaseGdax(responseData: coinbaseData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testCoinbaseParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.coinbaseGdax(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testCoinbaseParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.coinbaseGdax(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testCoinbaseParsingNumberOfObjects() {
        //given
        let coinbaseData = TestHelpers.coinbaseData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.coinbaseGdax(responseData: coinbaseData)
        
        //then
        XCTAssertNil(error, error!.localizedDescription)
        XCTAssertEqual(exchangeRates.count, 3)
    }
    
    public func testCoinbaseParsingObjectProperties() {
        //given
        let coinbaseData = TestHelpers.coinbaseSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.coinbaseGdax(responseData: coinbaseData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.coinbaseGdax)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.rate, 4167.99)
    }
    
    public func testKrakenParsingDoesntGiveError() {
        //given
        let krakenData = TestHelpers.krakenData
        
        //when
        let (_, error) = ExchangeRateParsing.kraken(responseData: krakenData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testKrakenParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.kraken(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testKrakenParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.kraken(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testKrakenParsingNumberOfObjects() {
        //given
        let krakenData = TestHelpers.krakenData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.kraken(responseData: krakenData)
        
        //then
        XCTAssertNil(error, error!.localizedDescription)
        XCTAssertEqual(exchangeRates.count, 17)
    }
    
    public func testKrakenParsingObjectProperties() {
        //given
        let krakenData = TestHelpers.krakenSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.kraken(responseData: krakenData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.kraken)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum:.bch))
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.rate, 441.7)
    }
    
    public func testKucoinParsingDoesntGiveError() {
        //given
        let kucoinData = TestHelpers.kucoinData
        
        //when
        let (_, error) = ExchangeRateParsing.kucoin(responseData: kucoinData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testKucoinParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.kucoin(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testKucoinParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.kucoin(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testKucoinParsingNumberOfObjects() {
        //given
        let krakenData = TestHelpers.kucoinData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.kucoin(responseData: krakenData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 52)
    }
    
    public func testKucoinParsingObjectProperties() {
        //given
        let krakenData = TestHelpers.kucoinSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.kucoin(responseData: krakenData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.kucoin)
        XCTAssertEqual(exchangeRate.from, Currency.rawValue("KCS"))
        XCTAssertEqual(exchangeRate.to, Currency.btc)
        XCTAssertEqual(exchangeRate.rate, 9.1370000000000001e-05)
    }
    
    public func testHitbtcParsingDoesntGiveError() {
        //given
        let hitbtcData = TestHelpers.hitbtcData
        
        //when
        let (_, error) = ExchangeRateParsing.hitbtc(responseData: hitbtcData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testHitbtcParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.hitbtc(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testHitbtcParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.hitbtc(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testHitbtcParsingNumberOfObjects() {
        //given
        let hitbtcData = TestHelpers.hitbtcData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.hitbtc(responseData: hitbtcData)
        
        //then
        XCTAssertNil(error, error!.localizedDescription)
        XCTAssertEqual(exchangeRates.count, 370)
    }
    
    public func testHitbtcParsingObjectProperties() {
        //given
        let hitbtcData = TestHelpers.hitbtcSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.hitbtc(responseData: hitbtcData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.hitbtc)
        XCTAssertEqual(exchangeRate.from, Currency.btc)
        XCTAssertEqual(exchangeRate.to, Currency.usd)
        XCTAssertEqual(exchangeRate.rate, 10669.74)
    }
    
    public func testBinanceParsingDoesntGiveError() {
        //given
        let binanceData = TestHelpers.binanceData
        
        //when
        let (_, error) = ExchangeRateParsing.binance(responseData: binanceData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testBinanceParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.binance(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testBinanceParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.binance(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testBinanceParsingNumberOfObjects() {
        //given
        let binanceData = TestHelpers.binanceData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.binance(responseData: binanceData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 176)
    }
    
    public func testBinanceParsingObjectProperties() {
        //given
        let binanceData = TestHelpers.binanceSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.binance(responseData: binanceData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.binance)
        XCTAssertEqual(exchangeRate.from, Currency.eth)
        XCTAssertEqual(exchangeRate.to, Currency.btc)
        XCTAssertEqual(exchangeRate.rate, 0.042555)
    }
    
    public func testBittrexParsingDoesntGiveError() {
        //given
        let bittrexData = TestHelpers.bittrexData
        
        //when
        let (_, error) = ExchangeRateParsing.bittrex(responseData: bittrexData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testBittrexParsingThrowsErrorOnEmptyData() {
        //given
        let bittrexData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.bittrex(responseData: bittrexData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testBittrexParsingThrowsErrorOnWrongData() {
        //given
        let bittrexData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.bittrex(responseData: bittrexData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testBittrexParsingNumberOfObjects() {
        //given
        let bittrexData = TestHelpers.bittrexData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.bittrex(responseData: bittrexData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 271)
    }
    
    public func testBittrexParsingObjectProperties() {
        //given
        let bittrexData = TestHelpers.bittrexSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.bittrex(responseData: bittrexData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.bittrex)
        XCTAssertEqual(exchangeRate.from, Currency.crypto(enum: .ltc))
        XCTAssertEqual(exchangeRate.to, Currency.crypto(enum: .btc))
        XCTAssertEqual(exchangeRate.rate, 0.017039)
    }

    public func testFixerParsingDoesntGiveError() {
        //given
        let fixerData = TestHelpers.fixerData
        
        //when
        let (_, error) = ExchangeRateParsing.fixer(responseData: fixerData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testFixerParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.fixer(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testFixerParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.fixer(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testFixerParsingNumberOfObjects() {
        //given
        let fixerData = TestHelpers.fixerData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.fixer(responseData: fixerData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 31)
    }
    
    public func testFixerParsingObjectProperties() {
        //given
        let fixerData = TestHelpers.fixerSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.fixer(responseData: fixerData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.fixer)
        XCTAssertEqual(exchangeRate.from, Currency.usd)
        XCTAssertEqual(exchangeRate.to, Currency.gbp)
        XCTAssertEqual(exchangeRate.rate, 0.74406)
    }
    
    public func testCurrencylayerParsingDoesntGiveError() {
        //given
        let currencylayerData = TestHelpers.currencylayerData
        
        //when
        let (_, error) = ExchangeRateParsing.currencylayer(responseData: currencylayerData)
        
        //then
        XCTAssertNil(error)
    }
    
    public func testCurrencylayerParsingThrowsErrorOnEmptyData() {
        //given
        let emptyData = TestHelpers.emptyData
        
        //when
        let (_, error) = ExchangeRateParsing.currencylayer(responseData: emptyData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testCurrencylayerParsingThrowsErrorOnWrongData() {
        //given
        let wrongData = TestHelpers.wrongData
        
        //when
        let (_, error) = ExchangeRateParsing.currencylayer(responseData: wrongData)
        
        //then
        XCTAssertNotNil(error)
    }
    
    public func testCurrencylayerParsingNumberOfObjects() {
        //given
        let currencylayerData = TestHelpers.currencylayerData
        
        //when
        let (exchangeRates, error) = ExchangeRateParsing.currencylayer(responseData: currencylayerData)
        
        //then
        XCTAssertNil(error, error!.errorDescription)
        XCTAssertEqual(exchangeRates.count, 168)
    }
    
    public func testCurrencylayerParsingObjectProperties() {
        //given
        let currencylayerData = TestHelpers.currencylayerSimpleData
        
        //when
        let (exchangeRates, _) = ExchangeRateParsing.currencylayer(responseData: currencylayerData)
        let exchangeRate = exchangeRates.first!
        
        //then
        XCTAssertEqual(exchangeRate.source, ExchangeRateSource.currencylayer)
        XCTAssertEqual(exchangeRate.from, Currency.usd)
        XCTAssertEqual(exchangeRate.to, Currency.rawValue("COP"))
        XCTAssertEqual(exchangeRate.rate, 2856.800049)
    }
}
