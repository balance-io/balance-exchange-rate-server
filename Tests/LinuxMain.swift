import BalanceServerTests
import IntegrationTests
import XCTest
@testable import BalanceServerLib


XCTMain([
    testCase(CurrencyTests.allTests), 
    //testCase(ConvertTests.allTests),
    testCase(ProfileTests.allTests),
    testCase(ParserTests.allTests),
    testCase(IntegrationTests.allTests)
])
