//
//  CurrencyRateDataModel.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

struct CurrencyRateDataModel: Decodable {
    let from: String
    let rate: String
    let to: String
}
