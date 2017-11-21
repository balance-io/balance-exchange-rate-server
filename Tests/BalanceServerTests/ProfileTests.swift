//
//  ProfileTests.swift
//  BalanceServerPackageDescription
//
//  Created by Benjamin Baron on 11/20/17.
//

import XCTest
@testable import BalanceServerLib

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
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test@test.com"
        let password = "test"
        
        //then
        XCTAssert(try! ProfileTable.register(email: email, password: password))
    }
    
    public func testExists() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test@test.com"
        let password = "test"
        _ = try! ProfileTable.register(email: email, password: password)
        
        //then
        XCTAssert(try! ProfileTable.exists(email: email))
    }
    
    public func testNotExists() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test@test.com"
        
        //then
        XCTAssert(try! !ProfileTable.exists(email: email))
    }
    
    public func testLogin() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test@test.com"
        let password = "test"
        _ = try! ProfileTable.register(email: email, password: password)
        
        //then
        let profile = try! ProfileTable.login(email: email, password: password)
        XCTAssert(profile != nil)
    }
    
    public func testRegisterAlreadyExists() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test@test.com"
        let password = "test"
        _ = try! ProfileTable.register(email: email, password: password)
        
        //then
        let success = try? ProfileTable.register(email: email, password: password)
        XCTAssert(success != true)
    }
    
    public func testLoginWrongEmail() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test2@test.com"
        let password = "test"
        
        //then
        let profile = try! ProfileTable.login(email: email, password: password)
        XCTAssert(profile == nil)
    }
    
    public func testLoginWrongPassword() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test@test.com"
        let password = "test"
        let wrongPassword = "test2"
        _ = try! ProfileTable.register(email: email, password: password)
        
        //then
        let profile = try! ProfileTable.login(email: email, password: wrongPassword)
        XCTAssert(profile == nil)
    }
    
    public func testLoginWrongEmailAndPassword() {
        //given
        ProfileTable.dropProfilesTable()
        ProfileTable.createProfilesTable()
        let email = "test2@test.com"
        let password = "test2"
        
        //then
        let profile = try! ProfileTable.login(email: email, password: password)
        XCTAssert(profile == nil)
    }
}
