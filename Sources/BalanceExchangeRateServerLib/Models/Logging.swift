//
//  Logging.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 1/29/18.
//

import Foundation
import PerfectLib

fileprivate var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS zzz"
    return dateFormatter
}()

public enum LogType: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
    case terminal = "TERMINAL"
}

// This is for use in our code, it includes more detailed information about where the log statement was called from
public struct BalanceLog {
    public static func log(type: LogType, message: String, file: String = #file, line: Int = #line, function: String = #function) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = NSURL(fileURLWithPath: file).deletingPathExtension?.lastPathComponent ?? file
        let functionName = function.components(separatedBy: "(").first ?? function
        
        print("[\(type.rawValue) \(timestamp) \(fileName):\(line) \(functionName)()] \(message)")
    }
    
    public static func debug(message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(type: .debug, message: message, file: file, line: line, function: function)
    }
    
    public static func info(message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(type: .info, message: message, file: file, line: line, function: function)
    }
    
    public static func warning(message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(type: .warning, message: message, file: file, line: line, function: function)
    }
    
    public static func error(message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(type: .error, message: message, file: file, line: line, function: function)
    }
    
    public static func critical(message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(type: .critical, message: message, file: file, line: line, function: function)
    }
    
    public static func terminal(message: String, file: String = #file, line: Int = #line, function: String = #function) {
        log(type: .terminal, message: message, file: file, line: line, function: function)
    }
}

// Since we can't change the code in Perfect, this improves their logging by adding a timestamp
public struct BetterConsoleLogger: Logger {
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

