//
//  String.swift
//  BalanceExchangeRateServer
//
//  Created by Benjamin Baron on 9/11/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation

#if os(Linux)
    // NOTE: arc4random_uniform doesn't exist in Swift on linux, so create our own
    // https://stackoverflow.com/a/41054566/299262
    public func arc4random_uniform(_ upper_bound: UInt32) -> UInt32 {
        srandom(UInt32(time(nil)))
        return UInt32(random() % 10000)
    }
#endif

public extension String {
    public static func random(_ length: Int = 32) -> String {
        let chars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let charsCount = UInt32(chars.count)
        
        var string = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(charsCount))
            let randomChar = chars[index]
            string.append(randomChar)
        }
        
        return string
    }
    
    //
    // MARK: - Easier indexing -
    //
    
    public func index(offset: Int) -> Index {
        return index(startIndex, offsetBy: offset)
    }
    
    public func substring(from: Int) -> String {
        let fromIndex = index(offset: from)
        return String(self[fromIndex..<endIndex])
    }
    
    public func substring(to: Int) -> String {
        let toIndex = index(offset: to)
        return String(self[startIndex..<toIndex])
    }
    
    public func substring(with r: Range<Int>) -> String {
        let startIndex = index(offset: r.lowerBound)
        let endIndex = index(offset: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    //
    // MARK: - URL Query Encoding -
    //
    
    // By default, the URLQueryAllowedCharacterSet is meant to allow encoding of entire query strings. This is
    // a problem because it won't handle, for example, a password containing an & character. So we need to remove
    // those characters from the character set. Then the stringByAddingPercentEncodingWithAllowedCharacters method
    // will work as expected.
    fileprivate static var URLQueryEncodedValueAllowedCharacters: CharacterSet = {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.remove(charactersIn: "?&=@+/'")
        return charSet
    }()
    
    // Used to encode individual query parameters
    public var URLQueryParameterEncodedValue: String {
        return self.addingPercentEncoding(withAllowedCharacters: String.URLQueryEncodedValueAllowedCharacters) ?? self
    }
    
    // Used to encode entire query strings
    public var URLQueryStringEncodedValue: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
}

// Allow for simple string exceptions
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
