//
//  DataProvider.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol DataProviderProtocol {
    func getPreparedTransactions(completion: @escaping (Result<[GroupOfTransactions], Error>) -> ())
}

struct PlistNames {
    static let rates = "rates"
    static let transactions = "transactions"
}

final class DataProvider: DataProviderProtocol {
    private let dataService: DataServiceProtocol
    private let converter: CurrencyConverterProtocol
    private let formatter: CurrencyFormatterProtocol
    private let targetCurrency: String
    
    init(dataService: DataServiceProtocol, converter: CurrencyConverterProtocol, formatter: CurrencyFormatterProtocol, targetCurrency: String = "GBP") {
        self.dataService = dataService
        self.converter = converter
        self.formatter = formatter
        self.targetCurrency = targetCurrency.uppercased()
    }
    
    func getPreparedTransactions(completion: @escaping (Result<[GroupOfTransactions], Error>) -> ()) {
        let dispatchGroup = DispatchGroup()
        
        var rawTransactions: [TransactionDataModel] = []
        var rawRates: [CurrencyRateDataModel] = []
        var loadError: Error?
        
        dispatchGroup.enter()
        dataService.loadPlist(named: PlistNames.transactions) { (result: Result<[TransactionDataModel], Error>) in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let transactions):
                rawTransactions = transactions
            case .failure(let error):
                loadError = error
            }
        }
        
        dispatchGroup.enter()
        dataService.loadPlist(named: PlistNames.rates) { (result: Result<[CurrencyRateDataModel], Error>) in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let rates):
                rawRates = rates
            case .failure(let error):
                loadError = error
            }
        }
        
        dispatchGroup.notify(queue: .global()) { [weak self] in
            guard let self else { return }
            
            if let error = loadError {
                completion(.failure(error))
                return
            }
            
            let rates = self.transformRates(rawRates: rawRates)
            let groupsOfTransactions = self.transformTransactions(rawTransactions: rawTransactions, rates: rates)
            completion(.success(groupsOfTransactions))
        }
    }
    
    private func transformRates(rawRates: [CurrencyRateDataModel]) -> [CurrencyRate] {
        let rates = rawRates.compactMap { rateData in
            if let rate = Double(rateData.rate) {
                return CurrencyRate(from: rateData.from.uppercased(), to: rateData.to.uppercased(), rate: rate)
            }
            return nil
        }
        return rates
    }
    
    private func transformTransactions(rawTransactions: [TransactionDataModel], rates: [CurrencyRate]) -> [GroupOfTransactions] {
        var transactionsDict: [String: [Transaction]] = [:]
        
        rawTransactions.forEach { rawTransaction in
            let baseCurrency = rawTransaction.currency.uppercased()
            let targetCurrency = targetCurrency.uppercased()
            
            guard let amount = Double(rawTransaction.amount), let convertedTargetAmount = converter.convert(amount: amount, fromCurrency: baseCurrency, toCurrency: targetCurrency, rates: rates) else { return } // { continue }
            
            let formattedBaseAmount = formatter.format(amount: amount, currencyCode: baseCurrency)
            
            let formattedTargetAmount = formatter.format(amount: convertedTargetAmount, currencyCode: targetCurrency)
            let transaction = Transaction(amount: amount, currency: baseCurrency, amountInTargetCurrency: convertedTargetAmount, formattedAmount: formattedBaseAmount, formattedAmountInTargetCurrency: formattedTargetAmount)
            
            transactionsDict[rawTransaction.sku, default: []].append(transaction)
        }
        
        let transactions = transactionsDict.map { sku, details in
            let amount = details.reduce(0) { $0 + $1.amountInTargetCurrency }
            let formattedAmount = formatter.format(amount: amount, currencyCode: targetCurrency)
            
            return GroupOfTransactions(sku: sku, transactions: details, targetCurrency: targetCurrency, amount: amount, formattedAmount: formattedAmount)
        }
        
        return transactions.sorted { $0.sku < $1.sku }
    }
}
