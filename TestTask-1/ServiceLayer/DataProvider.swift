//
//  DataProvider.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol DataProviderProtocol {
    func transformTransactionsData(_ transactionsData: [TransactionDataModel]) -> [Transaction]
    func transformRatesData(_ ratesData: [CurrencyRateDataModel]) -> [CurrencyRate]
}

final class DataProvider: DataProviderProtocol {
    
    func transformTransactionsData(_ transactionsData: [TransactionDataModel]) -> [Transaction] {
        var transactionsDict: [String: [TransactionDetail]] = [:]
        
        for transactionData in transactionsData {
            let baseCurrency = transactionData.currency.uppercased()
            guard let amount = Double(transactionData.amount) else { continue }
            
            let transactionDetail = TransactionDetail(
                sku: transactionData.sku,
                amount: amount,
                currency: baseCurrency)
            
            transactionsDict[transactionData.sku, default: []].append(transactionDetail)
        }
        
        let transactions = transactionsDict.map { Transaction(sku: $0, transactions: $1) }
        
        return transactions.sorted { $0.sku < $1.sku }
    }
    
    func transformRatesData(_ ratesData: [CurrencyRateDataModel]) -> [CurrencyRate] {
        let currencyRates = ratesData.compactMap { rateData in
            if let rate = Double(rateData.rate) {
                return CurrencyRate(from: rateData.from.uppercased(), to: rateData.to.uppercased(), rate: rate)
            }
            return nil
        }
        return currencyRates
    }
}
