//
//  MainModulePresenter.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol MainModulePresenterProtocol: AnyObject {
    func loadProducts()
    func tapOnTheTransaction(index: Int)
    var transactions: [Transaction]! { get set }
    var rates: [CurrencyRate]! { get set }
    var title: String { get }
}

protocol MainViewProtocol: AnyObject {
    func displayTransactions(_ transactions: [Transaction])
    func startSpinner()
    func stopSpinner()
    func showError(_ error: Error)
}

final class MainModulePresenter: MainModulePresenterProtocol {
    weak var view: MainViewProtocol?
    
    private var dataService: DataServiceProtocol
    private var dataProvider: DataProviderProtocol
    private var router: MainModuleRouterProtocol
    
    var transactions: [Transaction]!
    var rates: [CurrencyRate]!
    var title = "Products"
    
    init(dataService: DataServiceProtocol, dataProvider: DataProviderProtocol, router: MainModuleRouterProtocol) {
        self.dataService = dataService
        self.dataProvider = dataProvider
        self.router = router
    }
    
    func loadProducts() {
        dataService.loadPlist(named: .transactions) { [weak self] (result: Result<[TransactionDataModel], Error>) in
            guard let self else { return }
            
            view?.stopSpinner()
            
            switch result {
            case .success(let transactionsData):
                self.transactions = dataProvider.transformTransactionsData(transactionsData)
                view?.displayTransactions(transactions)
            case .failure(let error):
                self.view?.showError(error)
            }
        }
        
    }
    
    func tapOnTheTransaction(index: Int) {
        view?.startSpinner()
        let transaction = transactions[index]
        
        if rates == nil {
            getRates { [weak self] in
                guard let self else { return }
                
                view?.stopSpinner()
                router.openDetailModule(with: transaction, rates: self.rates)
            }
        } else {
            view?.stopSpinner()
            router.openDetailModule(with: transaction, rates: self.rates)
        }
    }
    
    private func getRates(completion: @escaping () -> ()) {
        dataService.loadPlist(named: .rates) { [weak self] (result: Result<[CurrencyRateDataModel], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let ratesData):
                self.rates = dataProvider.transformRatesData(ratesData)
                completion()
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
}
