//
//  ProfileTests.swift
//  BalanceExchangeRateServerPackageDescription
//
//  Created by Benjamin Baron on 11/20/17.
//

import XCTest
@testable import BalanceExchangeRateServerLib

public class ProfileTests: XCTestCase {
    public static var allTests : [(String, (ProfileTests) -> () throws -> Void)] {
        return [("testRegister", testRegister),
                ("testExists", testExists),
                ("testNotExists", testNotExists),
                ("testLogin", testLogin),
                ("testRegisterAlreadyExists", testRegisterAlreadyExists),
                ("testLoginWrongEmail", testLoginWrongEmail),
                ("testLoginWrongPassword", testLoginWrongPassword),
                ("testLoginWrongEmailAndPassword", testLoginWrongEmailAndPassword)]
    }
    
    public func testRegister() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test@test.com"
        let password = "test"
        
        //then
        var success = false
        XCTAssertNoThrow(success = try ProfileTable.register(email: email, password: password))
        XCTAssertTrue(success)
    }
    
    public func testExists() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test@test.com"
        let password = "test"
        XCTAssertNoThrow(_ = try ProfileTable.register(email: email, password: password))
        
        //then
        var exists = false
        XCTAssertNoThrow(exists = try ProfileTable.exists(email: email))
        XCTAssertTrue(exists)
    }
    
    public func testNotExists() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test@test.com"
        
        //then
        var exists = true
        XCTAssertNoThrow(exists = try ProfileTable.exists(email: email))
        XCTAssertFalse(exists)
    }
    
    public func testLogin() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test@test.com"
        let password = "test"
        XCTAssertNoThrow(_ = try ProfileTable.register(email: email, password: password))
        
        //then
        var profile: Profile? = nil
        XCTAssertNoThrow(profile = try ProfileTable.login(email: email, password: password))
        XCTAssertNotNil(profile)
    }
    
    public func testRegisterAlreadyExists() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test@test.com"
        let password = "test"
        XCTAssertNoThrow(_ = try! ProfileTable.register(email: email, password: password))
        
        //then
        XCTAssertThrowsError(_ = try ProfileTable.register(email: email, password: password))
    }
    
    public func testLoginWrongEmail() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test2@test.com"
        let password = "test"
        
        //then
        var profile: Profile? = nil
        XCTAssertNoThrow(profile = try ProfileTable.login(email: email, password: password))
        XCTAssertNil(profile)
    }
    
    public func testLoginWrongPassword() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test@test.com"
        let password = "test"
        let wrongPassword = "test2"
        XCTAssertNoThrow(_ = try! ProfileTable.register(email: email, password: password))
        
        //then
        var profile: Profile? = nil
        XCTAssertNoThrow(profile = try ProfileTable.login(email: email, password: wrongPassword))
        XCTAssertNil(profile)
    }
    
    public func testLoginWrongEmailAndPassword() {
        //given
        XCTAssertNoThrow(try ProfileTable.dropProfilesTable())
        XCTAssertNoThrow(try ProfileTable.createProfilesTable())
        let email = "test2@test.com"
        let password = "test2"
        
        //then
        var profile: Profile? = nil
        XCTAssertNoThrow(profile = try ProfileTable.login(email: email, password: password))
        XCTAssertNil(profile)
    }
}
