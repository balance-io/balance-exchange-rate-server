//
//  AppEngineHandlers.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/7/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import PerfectLib
import PerfectHTTP

public struct AppEngineHandlers {
    public static let routes = [["method": "get", "uri": "/_ah/health", "handler": healthHandler]]
    
    
    // Google Cloud health check endpoint. This handler is called periodically by Google Cloud
    // to ensure the service is up.
    public static func healthHandler(data: [String: Any]) throws -> RequestHandler {
        return {
            request, response in
            response.status = .ok
            response.completed()
        }
    }
}
