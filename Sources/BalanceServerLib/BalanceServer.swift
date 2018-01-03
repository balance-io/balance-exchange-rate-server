//
//  BalanceServer.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/27/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL

internal let sharedSession = URLSession(configuration: .default)

public struct BalanceServer {
    fileprivate static let routes = TestHandlers.routes + AppEngineHandlers.routes + BalanceHandlers.routes +
                                    CoinbaseHandlers.routes + ExchangeRatesHandlers.routes + ProfileHandlers.routes +
                                    FeedbackHandlers.routes

    fileprivate static let confData = [
        "servers": [
            [
                "name": Config.Server.name,
                "port": Config.Server.port,
                "routes": routes,
                "filters":[
                    [
                        "type": "response",
                        "priority": "high",
                        "name": PerfectHTTPServer.HTTPFilter.contentCompression,
                        ]
                ]
            ]
        ]
    ]

    public static func start() {
        do {
            // Launch the servers based on the configuration data.
            try HTTPServer.launch(configurationData: confData)
        } catch {
            fatalError("\(error)") // fatal error launching one of the servers
        }
    }
}
