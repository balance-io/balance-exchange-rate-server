//
//  Double.swift
//  BalanceServerLib
//
//  Created by Raimon Lapuente Ferran on 17/10/2017.
//

import Foundation

struct NumberUtils {
    static var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
}

extension Double {
    
    func integerFixedFiatDecimals() -> Int {
        let fixedDecimalsFiat = 2
        return self.integerValueWith(decimals:fixedDecimalsFiat)
    }
    
    func integerFixedCryptoDecimals() -> Int {
        let fixedDecimalsCrypto = 8
        return self.integerValueWith(decimals:fixedDecimalsCrypto)
    }
    
    func integerValueWith(decimals: Int) -> Int {
        let balanceString = String(format:"%f", self * Double(pow(10.0, Double(decimals))))
        let integerPart = balanceString.components(separatedBy: ".")[0]
        let availableDecimal = NumberUtils.decimalFormatter.number(from: integerPart)?.decimalValue
        return (availableDecimal! as NSDecimalNumber).intValue
    }
    
    func cientificToEightDecimals(decimals: Int) -> Double {
        if decimals < 8 {
            return self
        }
        let decimal = self / pow(10.0, Double(decimals))
        return decimal
    }
}
