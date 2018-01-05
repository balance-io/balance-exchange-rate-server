//
//  Config.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/6/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation

struct Config {
    struct Server {
        static let name = "localhost"
        static let port = 8081
    }
    
    struct MySQL {
        #if os(OSX) || DEBUG || CIRCLECI
            static let host = "127.0.0.1"
            static let user = "root"
            static let pass = "test"
            static let socket: String? = nil
        #else
            static let host: String? = PrivateConfig.MySQL.host
            static let user = PrivateConfig.MySQL.user
            static let pass = PrivateConfig.MySQL.pass
            static let socket = PrivateConfig.MySQL.socket
        #endif
    }
}
