//
//  BalanceExchangeRateServer.swift
//  BalanceExchangeRateServer
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

public struct BalanceExchangeRateServer {
    fileprivate static let routes = BalanceHandlers.routes + ExchangeRatesHandlers.routes

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
    
    public static func isCronjob(arguments: [String]) -> Bool {
        if arguments.count == 3 && arguments[1] == "cron" {
            return true
        }
        
        return false
    }
    
    public static func cronjobName(arguments: [String]) -> String {
        guard isCronjob(arguments: arguments) else {
            return ""
        }
        
        return arguments[2]
    }
    
    public static func printUsage(arguments: [String]) {
        let binaryName = arguments.first ?? ""
        print("To run a cron job: \(binaryName) cron jobName")
        print("Otherwise, run without any arguments to start the web server")
    }

    public static func start() {
        // Set Perfect to use our Logger
        Log.logger = BetterConsoleLogger()
        
        // Process arguments and run
        let arguments = CommandLine.arguments
        if isCronjob(arguments: arguments) {
            // Run the specified cronjob
            let name = cronjobName(arguments: arguments)
            Log.info(message: "Running cron job: \(name)")
            Cronjobs.runCronjob(withName: name) { exitCode in
                if exitCode == .success {
                    Log.info(message: "Finished running cron job: \(name)")
                } else if exitCode == .commandNotFound {
                    Log.error(message: "No a valid cron job: \(name)")
                } else {
                    Log.error(message: "Failed to run cron job: \(name)")
                }
                
                exit(exitCode.rawValue)
            }
            RunLoop.main.run(until: Date.distantFuture)
        } else if arguments.count > 1 && !arguments[0].contains("xctest") {
            // Print usage instructions
            printUsage(arguments: arguments)
            exit(ExitCode.commandNotFound.rawValue)
        } else {
            // Start the web server
            do {
                try HTTPServer.launch(configurationData: confData)
                exit(ExitCode.success.rawValue)
            } catch {
                fatalError("\(error)") // fatal error launching one of the servers
            }
        }
    }
}
