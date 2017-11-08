//
//  HandlersCommon.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/11/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import PerfectLib
import PerfectHTTP
import MySQL

public enum ResponseFields: String {
    case code
    case message
}

public func sendSuccessJsonResponse(dict: [AnyHashable: Any?], response: HTTPResponse) {
    var responseDict: [AnyHashable: Any?] = [ResponseFields.code.rawValue: BalanceError.success.rawValue]
    dict.forEach({ key, value in responseDict[key] = value })
    if let response = try? response.setBody(json: responseDict) {
        response.completed()
    } else {
        sendErrorJsonResponse(error: .jsonEncoding, response: response)
    }
}

public func sendErrorJsonResponse(error: BalanceError, response: HTTPResponse) {
    let responseDict: [String: Any?] = [ResponseFields.code.rawValue: error.rawValue,
                                        ResponseFields.message.rawValue: error.errorDescription ?? ""]
    if let response = try? response.setBody(json: responseDict) {
        response.completed()
        return
    }
    response.completed()
}

public func connectToMysql(db: String? = "balance") -> MySQL? {
    let mysql = MySQL()
    guard mysql.connect(host: Config.MySQL.host, user: Config.MySQL.user, password: Config.MySQL.pass, db: db, socket: Config.MySQL.socket) else {
        Log.error(message: "Failure connecting to mysql server host \(String(describing: Config.MySQL.host)) socket: \(String(describing: Config.MySQL.socket)) error: \(mysql.errorCode()) \(mysql.errorMessage())")
        return nil
    }
    return mysql
}

// NOTE: All valid cron jobs from Google come from IP address 0.1.0.1 and have the header "X-Appengine-Cron"
// NOTE NOTE: So the docs are totally wrong. For flex instances, it looks like ALL requests come from 172.17.0.1,
//            which is presumably the internal IP of the nginx proxy. So checking IP is actually not helpful at all.
public func isValidCronRequest(request: HTTPRequest) -> Bool {
    // Ensure proper header is included if we're not calling this from localhost
    #if os(OSX) || DEBUG
        return true
    #else
        guard request.header(.custom(name: "X-Appengine-Cron")) == "true" else {
            Log.error(message: "Not a valid cron job. The request does not contain the X-Appengine-Cron header set to true, headers: \(request.headers)")
            return false
        }
        return true
    #endif
}
