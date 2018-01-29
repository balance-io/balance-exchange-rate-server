// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import XCTest
import BalanceExchangeRateServerTests
import IntegrationTests
@testable import BalanceServerLib

extension CurrencyTests {
  static var allTests = [
    ("testBitcoinEquality", testBitcoinEquality),
    ("testNumberOfDecimalsForDollar", testNumberOfDecimalsForDollar),
    ("testNumberOfDecimalsForPound", testNumberOfDecimalsForPound),
    ("testNumberOfDecimalsForBTC", testNumberOfDecimalsForBTC),
    ("testNumberOfDecimalsForEther", testNumberOfDecimalsForEther),
    ("testNumberOfDecimalsForOtherCryptoSC", testNumberOfDecimalsForOtherCryptoSC),
    ("testNumberOfDecimalsForOtherCryptoXRP", testNumberOfDecimalsForOtherCryptoXRP),
    ("testTryCoin", testTryCoin),
  ]
}

extension IntegrationTests {
  static var allTests = [
    ("testHelloApiCall", testHelloApiCall),
  ]
}

extension ParserTests {
  static var allTests = [
    ("testParseFunctionNumberOfParsers", testParseFunctionNumberOfParsers),
    ("testPoloniexParsingDoesntGiveError", testPoloniexParsingDoesntGiveError),
    ("testPoloniexParsingThrowsErrorOnEmptyData", testPoloniexParsingThrowsErrorOnEmptyData),
    ("testPoloniexParsingThrowsErrorOnWrongData", testPoloniexParsingThrowsErrorOnWrongData),
    ("testPoloniexParsingNumberOfObjects", testPoloniexParsingNumberOfObjects),
    ("testPoloniexParsingObjectProperties", testPoloniexParsingObjectProperties),
    ("testBitfinexxParsingDoesntGiveError", testBitfinexxParsingDoesntGiveError),
    ("testBitfinexParsingThrowsErrorOnEmptyData", testBitfinexParsingThrowsErrorOnEmptyData),
    ("testBitfinexParsingThrowsErrorOnWrongData", testBitfinexParsingThrowsErrorOnWrongData),
    ("testBitfinexParsingNumberOfObjects", testBitfinexParsingNumberOfObjects),
    ("testBitfinexParsingObjectProperties", testBitfinexParsingObjectProperties),
    ("testCoinbaseParsingDoesntGiveError", testCoinbaseParsingDoesntGiveError),
    ("testCoinbaseParsingThrowsErrorOnEmptyData", testCoinbaseParsingThrowsErrorOnEmptyData),
    ("testCoinbaseParsingThrowsErrorOnWrongData", testCoinbaseParsingThrowsErrorOnWrongData),
    ("testCoinbaseParsingNumberOfObjects", testCoinbaseParsingNumberOfObjects),
    ("testCoinbaseParsingObjectProperties", testCoinbaseParsingObjectProperties),
    ("testKrakenParsingDoesntGiveError", testKrakenParsingDoesntGiveError),
    ("testKrakenParsingThrowsErrorOnEmptyData", testKrakenParsingThrowsErrorOnEmptyData),
    ("testKrakenParsingThrowsErrorOnWrongData", testKrakenParsingThrowsErrorOnWrongData),
    ("testKrakenParsingNumberOfObjects", testKrakenParsingNumberOfObjects),
    ("testKrakenParsingObjectProperties", testKrakenParsingObjectProperties),
    ("testKucoinParsingDoesntGiveError", testKucoinParsingDoesntGiveError),
    ("testKucoinParsingThrowsErrorOnEmptyData", testKucoinParsingThrowsErrorOnEmptyData),
    ("testKucoinParsingThrowsErrorOnWrongData", testKucoinParsingThrowsErrorOnWrongData),
    ("testKucoinParsingNumberOfObjects", testKucoinParsingNumberOfObjects),
    ("testKucoinParsingObjectProperties", testKucoinParsingObjectProperties),
    ("testHitbtcParsingDoesntGiveError", testHitbtcParsingDoesntGiveError),
    ("testHitbtcParsingThrowsErrorOnEmptyData", testHitbtcParsingThrowsErrorOnEmptyData),
    ("testHitbtcParsingThrowsErrorOnWrongData", testHitbtcParsingThrowsErrorOnWrongData),
    ("testHitbtcParsingNumberOfObjects", testHitbtcParsingNumberOfObjects),
    ("testHitbtcParsingObjectProperties", testHitbtcParsingObjectProperties),
    ("testBinanceParsingDoesntGiveError", testBinanceParsingDoesntGiveError),
    ("testBinanceParsingThrowsErrorOnEmptyData", testBinanceParsingThrowsErrorOnEmptyData),
    ("testBinanceParsingThrowsErrorOnWrongData", testBinanceParsingThrowsErrorOnWrongData),
    ("testBinanceParsingNumberOfObjects", testBinanceParsingNumberOfObjects),
    ("testBinanceParsingObjectProperties", testBinanceParsingObjectProperties),
    ("testBittrexParsingDoesntGiveError", testBittrexParsingDoesntGiveError),
    ("testBittrexParsingThrowsErrorOnEmptyData", testBittrexParsingThrowsErrorOnEmptyData),
    ("testBittrexParsingThrowsErrorOnWrongData", testBittrexParsingThrowsErrorOnWrongData),
    ("testBittrexParsingNumberOfObjects", testBittrexParsingNumberOfObjects),
    ("testBittrexParsingObjectProperties", testBittrexParsingObjectProperties),
    ("testBittrexParsingBitcoinCashProperties", testBittrexParsingBitcoinCashProperties),
    ("testFixerParsingDoesntGiveError", testFixerParsingDoesntGiveError),
    ("testFixerParsingThrowsErrorOnEmptyData", testFixerParsingThrowsErrorOnEmptyData),
    ("testFixerParsingThrowsErrorOnWrongData", testFixerParsingThrowsErrorOnWrongData),
    ("testFixerParsingNumberOfObjects", testFixerParsingNumberOfObjects),
    ("testFixerParsingObjectProperties", testFixerParsingObjectProperties),
    ("testCurrencylayerParsingDoesntGiveError", testCurrencylayerParsingDoesntGiveError),
    ("testCurrencylayerParsingThrowsErrorOnEmptyData", testCurrencylayerParsingThrowsErrorOnEmptyData),
    ("testCurrencylayerParsingThrowsErrorOnWrongData", testCurrencylayerParsingThrowsErrorOnWrongData),
    ("testCurrencylayerParsingNumberOfObjects", testCurrencylayerParsingNumberOfObjects),
    ("testCurrencylayerParsingObjectProperties", testCurrencylayerParsingObjectProperties),
  ]
}


XCTMain([
  testCase(CurrencyTests.allTests),
  testCase(IntegrationTests.allTests),
  testCase(ParserTests.allTests),
])
