//
//  Cronjobs.swift
//  BalanceExchangeRateServerLib
//
//  Created by Benjamin Baron on 1/8/18.
//

import Foundation

public typealias CronFunction = (@escaping CronCompletionHandler) -> Void
public typealias CronCompletionHandler = (ExitCode) -> Void

public enum ExitCode: Int32 {
    case success = 0
    case generalError = 1
    case commandNotFound = 127
}

public struct Cronjobs {
    public static let allCronjobs: [String: CronFunction] = ExchangeRateCronjobs.allCronjobs
    
    public static func runCronjob(withName name: String, completion: @escaping CronCompletionHandler) {
        guard let cronjob = allCronjobs[name] else {
            completion(.commandNotFound)
            return
        }
        
        cronjob(completion)
    }
}
