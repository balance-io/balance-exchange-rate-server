//
//  EmailTests.swift
//  BalanceServerTests
//
//  Created by Benjamin Baron on 12/7/17.
//

import Foundation
import XCTest
@testable import BalanceServerLib

public class EmailTests: XCTestCase {
    private let mockSession = MockSession()
    
    override public func setUp() {
        super.setUp()
        loadResponses()
    }
    
    public func testSuccess() {
        //given
        let expectation = self.expectation(description: "testSuccess")
        
        //when
        Email.send(from: "Balance Support <support@balancemy.money>", to: "test@balancemy.money", subject: "Test subject", body: "Test body", urlString: "success", session: mockSession) { error in
            
            //then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    public func testNoParameters() {
        //given
        let expectation = self.expectation(description: "testNoParameters")
        
        //when
        Email.send(from: "", to: "", subject: "", body: "", urlString: "noParameters", session: mockSession) { error in
            
            //then
            XCTAssertEqual(error, BalanceError.unknownError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    public func testMissingToParameter() {
        //given
        let expectation = self.expectation(description: "testMissingToParameter")
        
        //when
        Email.send(from: "", to: "", subject: "", body: "", urlString: "missingToParameter", session: mockSession) { error in
            
            //then
            XCTAssertEqual(error, BalanceError.unknownError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    public func testMissingTextParameter() {
        //given
        let expectation = self.expectation(description: "testMissingTextParameter")
        
        //when
        Email.send(from: "", to: "", subject: "", body: "", urlString: "missingTextParameter", session: mockSession) { error in
            
            //then
            XCTAssertEqual(error, BalanceError.unknownError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    public func testWrongApiKey() {
        //given
        let expectation = self.expectation(description: "testWrongApiKey")
        
        //when
        Email.send(from: "", to: "", subject: "", body: "", urlString: "wrongApiKey", session: mockSession) { error in
            
            //then
            XCTAssertEqual(error, BalanceError.unexpectedData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    public func testEmptyData() {
        //given
        let expectation = self.expectation(description: "testEmptyData")
        
        //when
        Email.send(from: "", to: "", subject: "", body: "", urlString: "emptyData", session: mockSession) { error in
            
            //then
            XCTAssertEqual(error, BalanceError.jsonDecoding)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    public func testWrongData() {
        //given
        let expectation = self.expectation(description: "testWrongData")
        
        //when
        Email.send(from: "", to: "", subject: "", body: "", urlString: "wrongData", session: mockSession) { error in
            
            //then
            XCTAssertEqual(error, BalanceError.jsonDecoding)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
    
    private func loadResponses() {
        let success = MockSession.Response(urlPattern: "success", data: TestHelpers.emailSuccessResponseData, statusCode: TestHelpers.emailSuccessStatusCode, headers: nil)
        mockSession.mockResponses.append(success)
        
        let noParameters = MockSession.Response(urlPattern: "noParameters", data: TestHelpers.emailNoParametersResponseData, statusCode: TestHelpers.emailNoParametersStatusCode, headers: nil)
        mockSession.mockResponses.append(noParameters)
        
        let missingToParameter = MockSession.Response(urlPattern: "missingToParameter", data: TestHelpers.emailMissingToParameterResponseData, statusCode: TestHelpers.emailMissingToParameterStatusCode, headers: nil)
        mockSession.mockResponses.append(missingToParameter)
        
        let missingTextParameter = MockSession.Response(urlPattern: "missingTextParameter", data: TestHelpers.emailMissingTextParameterResponseData, statusCode: TestHelpers.emailMissingTextParameterStatusCode, headers: nil)
        mockSession.mockResponses.append(missingTextParameter)
        
        let wrongApiKey = MockSession.Response(urlPattern: "wrongApiKey", data: TestHelpers.emailWrongApiKeyResponseData, statusCode: TestHelpers.emailWrongApiKeyStatusCode, headers: nil)
        mockSession.mockResponses.append(wrongApiKey)
        
        let emptyData = MockSession.Response(urlPattern: "emptyData", data: TestHelpers.emptyData, statusCode: 200, headers: nil)
        mockSession.mockResponses.append(emptyData)
        
        let wrongData = MockSession.Response(urlPattern: "wrongData", data: TestHelpers.wrongData, statusCode: 200, headers: nil)
        mockSession.mockResponses.append(wrongData)
    }
}
