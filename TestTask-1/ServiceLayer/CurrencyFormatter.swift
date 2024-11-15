//
//  CurrencyFormatter.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation

protocol CurrencyFormatterProtocol {
    func format(amount: Double, currencyCode: String) -> String
}

final class CurrencyFormatter: CurrencyFormatterProtocol {
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    func format(amount: Double, currencyCode: String) -> String {
        numberFormatter.currencyCode = currencyCode
        
        return numberFormatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
