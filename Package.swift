//
//  Package.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/6/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "BalanceServer",
    targets: [
      Target(name: "BalanceServerLib"),
      Target(name: "BalanceServer", dependencies: ["BalanceServerLib"])
    ],
    dependencies: [
        .Package(url:"https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2)
    ]
)