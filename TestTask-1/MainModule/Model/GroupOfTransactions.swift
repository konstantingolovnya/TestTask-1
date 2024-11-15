//
//  Transaction.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

struct GroupOfTransactions {
    let sku: String
    let transactions: [Transaction]
    let targetCurrency: String
    let amount: Double
    let formattedAmount: String
}

struct Transaction {
    let amount: Double
    let currency: String
    let amountInTargetCurrency: Double
    let formattedAmount: String
    let formattedAmountInTargetCurrency: String
}
