//
//  CurrencyConverter.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol CurrencyConverterProtocol {
    func convert(amount: Double, fromCurrency: String, toCurrency: String, rates: [CurrencyRate]) -> Double?
}

final class CurrencyConverter: CurrencyConverterProtocol {
    func convert(amount: Double, fromCurrency: String, toCurrency: String, rates: [CurrencyRate]) -> Double? {
        
        if fromCurrency == toCurrency {
            return amount
        }
        
        if let conversationRate = findConversionRate(from: fromCurrency, to: toCurrency, in: rates) {
            return amount * conversationRate
        }
        return nil
    }
    
    private func findConversionRate(from: String, to: String, in rates: [CurrencyRate]) -> Double? {
        if let directRate = findDirectRate(from: from, to: to, in: rates) {
            return directRate
        }
        
        for rate in rates {
            if rate.from == from {
                if let intermediateRate = findConversionRate(from: rate.to, to: to, in: rates) {
                    return rate.rate * intermediateRate
                }
            }
        }
        return nil
    }
    
    private func findDirectRate(from: String, to: String, in rates: [CurrencyRate]) -> Double? {
        let rate = rates.first(where: { $0.from == from && $0.to == to })?.rate
        return rate
    }
}
