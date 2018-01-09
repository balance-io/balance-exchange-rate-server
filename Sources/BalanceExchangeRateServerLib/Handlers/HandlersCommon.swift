//
//  HandlersCommon.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/11/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectMySQL

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
