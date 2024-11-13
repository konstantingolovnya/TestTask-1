//
//  TransactionDataModel.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

struct TransactionDataModel: Decodable {
    let amount: String
    let currency: String
    let sku: String
}
