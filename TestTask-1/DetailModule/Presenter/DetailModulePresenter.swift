//
//  DetailModulePresenter.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation

protocol DetailModulePresenterProtocol {
    func prepareTransactions()
    var transaction: Transaction { get }
    var title: String { get }
}

protocol DetailModuleViewProtocol: AnyObject {
    func displayTransactions(_ model: DetailModuleView.Model)
}

final class DetailModulePresenter: DetailModulePresenterProtocol {
    weak var view: DetailModuleViewProtocol?
    let transaction: Transaction
    let title: String
    let converter: CurrencyConverterProtocol
    let formatter: CurrencyFormatterProtocol
    let targetCurrency: String
    
    typealias TemporaryTransaction = (originalCurrency: String, originalAmount: Double, targetCurrency: String, targetAmount: Double)
    
    init(transaction: Transaction, converter: CurrencyConverterProtocol, formatter: CurrencyFormatterProtocol, targetCurrency: String = "GBP") {
        self.transaction = transaction
        self.title = "Transactions for \(transaction.sku)"
        self.converter = converter
        self.formatter = formatter
        self.targetCurrency = targetCurrency.uppercased()
    }
    
    func prepareTransactions() {
        let convertedTransactions = convertTransactionsAmount()
        let formattedTransactions = formatTransactions(convertedTransactions)
        
        let totalAmount = convertedTransactions.reduce(0) { $0 + $1.targetAmount }
        let formattedTotalAmount = formatter.format(amount: totalAmount, currencyCode: targetCurrency.uppercased())
    
        view?.displayTransactions(DetailModuleView.Model(total: formattedTotalAmount, transactions: formattedTransactions))
    }
    
    private func convertTransactionsAmount() -> [TemporaryTransaction] {
        let convertedTransactions = transaction.transactions.compactMap { detail in
            
            if let targetAmount = converter.convert(amount: detail.amount, fromCurrency: detail.currency, toCurrency: targetCurrency) {
                
                let convertedTransaction = (detail.currency, detail.amount, targetCurrency.uppercased(), targetAmount)
                return convertedTransaction
            }
            return nil
        }
        return convertedTransactions
    }
    
    private func formatTransactions(_ transactions: [TemporaryTransaction]) -> [DetailModuleView.Model.FormattedTransaction] {
        let formattedTransactions = transactions.map { transaction in
            let formatedOriginalAmount = formatter.format(amount: transaction.originalAmount, currencyCode: transaction.originalCurrency)
            let formatedTargetAmount = formatter.format(amount: transaction.targetAmount, currencyCode: transaction.targetCurrency)
            
            let formattedTransaction = DetailModuleView.Model.FormattedTransaction(amountInOriginalCurrency: formatedOriginalAmount, amountInTargetCurrency: formatedTargetAmount)
            return formattedTransaction
        }
        return formattedTransactions
    }
}
