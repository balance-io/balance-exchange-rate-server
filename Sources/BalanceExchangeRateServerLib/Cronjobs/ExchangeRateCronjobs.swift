//
//  ExchangeRateCronjobs.swift
//  BalanceExchangeRateServerLib
//
//  Created by Benjamin Baron on 1/8/18.
//

import Foundation

public struct ExchangeRateCronjobs {
    public static let allCronjobs: [String: CronFunction] = ["updateAllCrypto": updateAllCrypto,
                                                             "updateAllFiat":   updateAllFiat,
                                                             "rotateTables":    rotateTables]
    
    // NOTE: Called once per minute by a cron job
    public static func updateAllCrypto(completion: @escaping CronCompletionHandler) {
        update(sources: ExchangeRateSource.allCrypto, session: sharedSession, completion: completion)
    }

    // NOTE: Called once per day by a cron job
    public static func updateAllFiat(completion: @escaping CronCompletionHandler) {
        update(sources: ExchangeRateSource.allFiat, session: sharedSession, completion: completion)
    }
    
    public static func update(sources: [ExchangeRateSource], session: DataSession = sharedSession, completion: @escaping CronCompletionHandler) {
        ExchangeRates.updateExchangeRates(sources: sources, session: session)
        completion(.success)
    }
    
    // NOTE: Called once per month by a cron job
    public static func rotateTables(completion: @escaping CronCompletionHandler) {
        // Always have current and next table, this cron job creates next week's table if needed
        ExchangeRateTable.rotate()
        completion(.success)
    }
}
