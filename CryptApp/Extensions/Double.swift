//
//  Double.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-26.
//

import Foundation

extension Double {
    
    /// Convert a Double into a Currency with 2-6 decimal places
    ///```
    ///Convert 1234.56 into $1,234.56
    ///Convert 12.5678 into $12.5678
    ///Convert 0.567891 into $0.567891
    ///```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    
    /// Convert a Double into a Currency as a String with 2-6 decimal places
    ///```
    ///Convert 1234.56 into "$1,234.56"
    ///Convert 12.5678 into "$12.5678"
    ///Convert 0.567891 into "$0.567891"
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Convert a Double into a Currency with 2 decimal places
    ///```
    ///Convert 1234.56 into $1,234.56
    ///```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    func asPercentString() -> String {
        return String(format: "%.2f", self) + "%"
    }
    
    /// Convert a Double into a Currency as a String with 2 decimal places
    ///```
    ///Convert 1234.56 into "$1,234.56"
    ///```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
}
