//
//  Config.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/6/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation

struct Config {
    struct AppEngine {
        static let name = "localhost"
        static let port = 8080
    }
    
    struct MySQL {
        #if os(OSX) || DEBUG
        static let host = "127.0.0.1"
        static let user = "root"
        static let pass = ""
        static let socket: String? = nil
        #else
        static let host: String? = nil
        static let user = ""
        static let pass = ""
        static let socket = ""
        #endif
    }
}
