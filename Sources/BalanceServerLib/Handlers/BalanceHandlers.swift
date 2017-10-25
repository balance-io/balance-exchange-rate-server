//
//  BalanceHandlers.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/13/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import PerfectLib
import PerfectHTTP

public struct BalanceHandlers {
    public static let routes = [["method": "get", "uri": "/hello", "handler": helloHandler]]
    
    // MARK: - Handlers -
    
    // Network check to ensure network access is working. Respond with a simple hello message
    // that the app can check for
    public static func helloHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            response.setHeader(.contentType, value: "text/plain; charset=utf-8")
            response.setBody(string: "hello")
            response.completed()
        }
    }
}
