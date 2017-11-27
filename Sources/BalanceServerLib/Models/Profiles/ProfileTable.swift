//
//  ProfileTable.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 11/8/17.
//

import Foundation
import PerfectLib
import PerfectBCrypt
import PerfectMySQL

public struct ProfileTable {
    public static func hashPassword(password: String) throws -> String {
        let salt = try BCrypt.Salt(._2B, rounds: 12)
        let hash = try BCrypt.Hash(password, salt: salt)
        return hash
    }
    
    public static func checkPassword(password: String, hashed: String) throws -> Bool {
        #if os(Linux)
            return BCrypt.Check(password, hashed: hashed)
        #else
            if #available(OSX 10.12.1, *) {
                return BCrypt.Check(password, hashed: hashed)
            }
            return false
        #endif
    }
    
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
    
    public static func register(email: String, password: String, mysql: MySQL? = connectToMysql()) throws -> Bool {
        guard try !exists(email: email) else {
            throw BalanceError.invalidInputData
        }
        
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let passwordHash = try hashPassword(password: password)
        let query = "INSERT INTO profiles VALUES (NULL, ?, ?, NOW(), NOW(), NULL, 0)"
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

        return true
    }
    
    public static func isLocked(loginFailures: UInt8, lastLoginAttempt: Date) -> Bool {
        // Locked if more than 10 login failures in a row, with the last attempt less than an hour ago
        return loginFailures >= 10 && Date().timeIntervalSince(lastLoginAttempt) < 60 * 60
    }
    
    public static func updateSuccessfulLogin(profileId: UInt32, mysql: MySQL? = connectToMysql()) throws {
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "UPDATE profiles SET lastLogin = NOW(), lastLoginAttempt = NOW(), loginFailures = 0 WHERE profileId = ?"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query) else {
            throw BalanceError.databaseError
        }
        statement.bindParam(UInt64(profileId))
        guard statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
    }
    
    public static func updateFailedLogin(email: String, failedLogins: UInt64, mysql: MySQL? = connectToMysql()) throws {
        // TODO: increment loginFailures, set lastLoginAttempt to date
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        // Don't allow the query to fail because of integer overflow
        let loginFailures = failedLogins >= 255 ? 255 : failedLogins + 1
        
        let query = "UPDATE profiles SET lastLoginAttempt = NOW(), loginFailures = ? WHERE email = ?"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query) else {
            throw BalanceError.databaseError
        }
        statement.bindParam(loginFailures)
        statement.bindParam(email)
        guard statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
    }
    
    public static func login(email: String, password: String, mysql: MySQL? = connectToMysql()) throws -> Profile? {
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "SELECT profileId, password, created, lastLoginAttempt, loginFailures FROM profiles WHERE email = ? LIMIT 1"
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
        if results.numRows == 0 {
            // Account doesn't exist at all
            return nil
        } else {
            var profile: Profile?
            var failedLogins: UInt64 = 0
            _ = results.forEachRow { element in
                guard element.count == 5, let profileId = element[0] as? UInt32, let hashed = element[1] as? String, let createdString = element[2] as? String, let created = Date.from(mysqlFormatted: createdString), let loginFailures = element[4] as? UInt8 else {
                    return
                }
                
                var lastLoginAttempt = Date.distantPast
                if let lastLoginAttemptString = element[3] as? String, let lastLoginAttemptDate = Date.from(mysqlFormatted: lastLoginAttemptString) {
                    lastLoginAttempt = lastLoginAttemptDate
                }
                failedLogins = UInt64(loginFailures)
                
                // Check if account is locked
                if isLocked(loginFailures: loginFailures, lastLoginAttempt: lastLoginAttempt) {
                    return
                }
                
                // Check the password matches
                do {
                    if try checkPassword(password: password, hashed: hashed) {
                        profile = Profile(profileId: profileId, email: email, created: created)
                    }
                } catch {
                    Log.error(message: "login: exception in bcrypt: \(error)")
                }
            }
            
            if let profile = profile {
                try updateSuccessfulLogin(profileId: profile.profileId)
            } else {
                try updateFailedLogin(email: email, failedLogins: failedLogins)
            }
            
            return profile
        }
    }
    
    public static func createProfilesTable(mysql: MySQL? = connectToMysql()) throws {
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "CREATE TABLE IF NOT EXISTS profiles (profileId INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, email VARCHAR(255) UNIQUE, password CHAR(60) BINARY, created DATETIME, lastLogin DATETIME, lastLoginAttempt DATETIME, loginFailures TINYINT UNSIGNED)"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query), statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
    }
    
    public static func dropProfilesTable(mysql: MySQL? = connectToMysql()) throws {
        guard let mysql = mysql else {
            throw BalanceError.databaseError
        }
        
        defer {
            mysql.close()
        }
        
        let query = "DROP TABLE IF EXISTS profiles"
        let statement = MySQLStmt(mysql)
        guard statement.prepare(statement: query), statement.execute() else {
            Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
            throw BalanceError.databaseError
        }
    }
}
