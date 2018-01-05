//
//  Date.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/29/17.
//

import Foundation

public let mysqlDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

public let jsonDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    // NOTE: Calendar with identifier iso8601 currently causes a runtime crash on Linux
    //formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
}()

extension Date {
    public static func from(mysqlFormatted: String) -> Date? {
        return mysqlDateFormatter.date(from: mysqlFormatted)
    }
    
    public var mysqlFormatted: String {
        return mysqlDateFormatter.string(from: self)
    }
    
    public static func from(jsonFormatted: String) -> Date? {
        return jsonDateFormatter.date(from: jsonFormatted)
    }
    
    public var jsonFormatted: String {
        return jsonDateFormatter.string(from: self)
    }
}
