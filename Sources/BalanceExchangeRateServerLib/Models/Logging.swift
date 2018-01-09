//
//  Logging.swift
//  BalanceExchangeRateServerLib
//
//  Created by Benjamin Baron on 1/8/18.
//

import Foundation
import PerfectLib

public enum LogType: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
    case terminal = "TERMINAL"
}

public struct BetterConsoleLogger: Logger {
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS zzz"
        return dateFormatter
    }()
    
    public func log(type: LogType, message: String, _ even: Bool) {
        let timestamp = dateFormatter.string(from: Date())
        print("[\(type.rawValue) \(timestamp)]\(even ? "  " : " ")\(message)")
    }
    
    public func debug(message: String, _ even: Bool) {
        log(type: .debug, message: message, even)
    }
    
    public func info(message: String, _ even: Bool) {
        log(type: .info, message: message, even)
    }
    
    public func warning(message: String, _ even: Bool) {
        log(type: .warning, message: message, even)
    }
    
    public func error(message: String, _ even: Bool) {
        log(type: .error, message: message, even)
    }
    
    public func critical(message: String, _ even: Bool) {
        log(type: .critical, message: message, even)
    }
    
    public func terminal(message: String, _ even: Bool) {
        log(type: .terminal, message: message, even)
    }
}
