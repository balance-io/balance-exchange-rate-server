//
//  Handlers.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/6/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MySQL

public struct TestHandlers {
    // If you want to serve static files, add the following entry to the routes dictionary. In this case
    // it will serve any file inside the "./webroot" directory (which must be located in the current working directory).
    // ["method": "get", "uri": "/**", "handler": PerfectHTTPServer.HTTPHandler.staticFiles, "documentRoot":"./webroot", "allowResponseFilters":true]
    public static let routes = [["method": "get", "uri": "/animals", "handler": animalsHandler]]
    
    fileprivate static let mysql = MySQL()
    public static func animalsHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            defer {
                response.completed()
            }
            
            // need to make sure something is available.
            guard mysql.connect(host: Config.MySQL.host, user: Config.MySQL.user, password: Config.MySQL.pass, db: "balance", socket: Config.MySQL.socket) else {
                Log.error(message: "Failure connecting to mysql server host \(String(describing: Config.MySQL.host)) socket: \(String(describing: Config.MySQL.socket)) error: \(mysql.errorCode()) \(mysql.errorMessage())")
                return
            }
            
            defer {
                mysql.close()  // defer ensures we close our db connection at the end of this request
            }
            
            let query = "SELECT * FROM animals"
            let statement = MySQLStmt(mysql)
            guard statement.prepare(statement: query), statement.execute() else {
                Log.error(message: "Failure to run statement: \(mysql.errorCode()) \(mysql.errorMessage())")
                return
            }
            
            let results = statement.results()
            
            var resultArray = [[Any?]]()
            _ = results.forEachRow { element in
                var row = [Any?]()
                for i in 0 ..< element.count {
                    row.append(element[i])
                }
                resultArray.append(row)
            }
            
            //return array to http response
            response.appendBody(string: "<html><title>Mysql Test</title><body>\(resultArray)</body></html>")
        }
    }
}
