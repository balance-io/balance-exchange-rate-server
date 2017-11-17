//
//  IntegrationTests.swift
//  IntegrationTests
//
//  Created by Raimon Lapuente Ferran on 04/10/2017.
//

import XCTest
import Foundation

class IntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func notestHelloApiCall() {
        self.checkHost()
    }
    
    fileprivate func checkHost() {
        //given
//        let expectation = XCTestExpectation(description: "Get hello string")
        let url = URL(string: "http://0.0.0.0:8080/hello")!
        let expectedResponse = "hello"
        let datatask = URLSession.shared.dataTask(with: url) { data, response, error in
            
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
//                expectation.fulfill()
            }
        }
        
        //when
        datatask.resume()
//        wait(for: [expectation], timeout: 2.0)
    }
}
