//
//  IntegrationTests.swift
//  IntegrationTests
//
//  Created by Raimon Lapuente Ferran on 04/10/2017.
//

import XCTest
import Foundation
import BalanceExchangeRateServerLib
import PerfectThread

public class IntegrationTests: XCTestCase {
	public static var allTests : [(String, (IntegrationTests) -> () throws -> Void)] {
        return [("testHelloApiCall", testHelloApiCall)]
    }    

    override public func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    	
        Threading.dispatch {
            BalanceExchangeRateServer.start()
        } 
	}
    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    public func testHelloApiCall() {
        self.checkHost()
    }
    
    private func checkHost() {
        //given
        let expectation = self.expectation(description: "Get hello string")
        let url = URL(string: "http://0.0.0.0:8081/hello")!
        let expectedResponse = "hello"
        let session = URLSession(configuration: .default)
        let datatask = session.dataTask(with: url) { data, response, error in
            
            //then
            do {
                guard let safeData = data else {
                    return
                }
                guard let response = String(data: safeData, encoding: .utf8), response == expectedResponse else {
                return
                }
                XCTAssertNil(error)
                XCTAssertEqual(response, expectedResponse)
                expectation.fulfill()
            }
        }
        
        //when
        datatask.resume()
        waitForExpectations(timeout: 2.0)
    }
}
