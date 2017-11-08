//
//  ProfileTable.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 11/8/17.
//

import Foundation
import PerfectLib
import PerfectBCrypt
import MySQL

public struct ProfileTable {
    public static func hashPassword(password: String) throws -> String {
        let salt = try BCrypt.Salt(._2B, rounds: 12)
        let hash = try BCrypt.Hash(password, salt: salt)
        return hash
    }
    
    #if os(Linux)
        public static func checkPassword(password: String, hashed: String) throws -> Bool {
            return BCrypt.Check(password, hashed: hashed)
        }
    #else
        @available(OSX 10.12.1, *)
        public static func checkPassword(password: String, hashed: String) throws -> Bool {
            return BCrypt.Check(password, hashed: hashed)
        }
    #endif
    
    public static func exists(email: String, mysql: MySQL? = connectToMysql()) throws -> Bool {
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "SELECT * FROM profiles WHERE email = ? LIMIT 1"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query) else {
            throw BalanceError.databaseError
        }
        statement.bindParam(email)
        guard statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
        
        let results = statement.results()
        return results.numRows > 0
    }
    
    public static func register(email: String, password: String) throws -> Profile? {
        guard try !exists(email: email) else {
            throw BalanceError.invalidInputData
        }
        
        guard let mysql = connectToMysql() else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let passwordHash = try hashPassword(password: password)
        let query = "INSERT INTO profiles VALUES (NULL, ?, ?, NOW(), NOW(), 0)"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query) else {
            throw BalanceError.databaseError
        }
        statement.bindParam(email)
        statement.bindParam(passwordHash)
        guard statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }

        return try login(email: email, password: password)
    }
    
    public static func login(email: String, password: String) throws -> Profile? {
        guard let mysql = connectToMysql() else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let passwordHash = try hashPassword(password: password)
        let query = "SELECT (profileId, created) FROM profiles WHERE email = ? AND password = ? LIMIT 1"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query) else {
            throw BalanceError.databaseError
        }
        statement.bindParam(email)
        statement.bindParam(passwordHash)
        guard statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
        
        let results = statement.results()
        if results.numRows == 0 {
            // Account doesn't exist
            // TODO: Increment failed login attempts
            return nil
        } else {
            // TODO: Check failed login attempts
            // TODO: Lock accounts for 1 hour after 10 failed attempts
            var profile: Profile?
            _ = results.forEachRow { element in
                guard let profileId = element[0] as? UInt32, let created = element[1] as? Date else {
                    return
                }
                
                profile = Profile(profileId: profileId, email: email, created: created)
            }
            
            return profile
        }
    }
    
    public static func createTable() -> Bool {
        guard let mysql = connectToMysql() else {
            return false
        }
        
        defer {
            mysql.close()
        }
        
        let query = "CREATE TABLE IF NOT EXISTS profiles (profileId INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, email VARCHAR(255) UNIQUE, password CHAR(60) BINARY, created DATETIME, lastLogin DATETIME, loginFailures TINYINT UNSIGNED)"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query), statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            return false
        }
        
        return true
    }
    
    public static func dropTable() -> Bool {
        guard let mysql = connectToMysql() else {
            return false
        }
        
        defer {
            mysql.close()
        }
        
        let query = "DROP TABLE profiles"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query), statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            return false
        }
        
        return true
    }
}
