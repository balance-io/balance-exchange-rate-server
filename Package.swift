//
//  Package.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/6/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "BalanceExchangeRateServer",
    targets: [
      Target(name: "BalanceExchangeRateServerLib"),
      Target(name: "BalanceExchangeRateServer", dependencies: ["BalanceExchangeRateServerLib"])
    ],
    dependencies: [
        .Package(url:"https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 3),
        .Package(url:"https://github.com/PerfectSideRepos/PerfectBCrypt.git", majorVersion: 3)
    ]
)
