//
//  Transaction.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

struct Transaction {
    let sku: String
    var transactions: [TransactionDetail]
}

struct TransactionDetail {
    let sku: String
    let amount: Double
    let currency: String
}
