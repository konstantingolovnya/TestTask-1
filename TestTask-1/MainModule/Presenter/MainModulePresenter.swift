//
//  MainModulePresenter.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol MainModulePresenterProtocol: AnyObject {
    func viewDidLoad()
    func tapOnTheGroup(index: Int)
    var title: String { get }
    func retryLoadingData()
}

protocol MainViewProtocol: AnyObject {
    func displayTransactions(_ transactions: [GroupOfTransactions])
    func startSpinner()
    func stopSpinner()
    func showError(_ error: Error)
    func showEmpty()
}

final class MainModulePresenter: MainModulePresenterProtocol {
    weak var view: MainViewProtocol?
    
    private var dataProvider: DataProviderProtocol
    private var router: MainModuleRouterProtocol
    
    private var transactions: [GroupOfTransactions]!
    let title = "Products"
    
    init(dataProvider: DataProviderProtocol, router: MainModuleRouterProtocol) {
        self.dataProvider = dataProvider
        self.router = router
    }
    
    func viewDidLoad() {
        view?.startSpinner()
        dataProvider.getPreparedTransactions { [weak self] result in
            guard let self else { return }
            self.view?.stopSpinner()
            
            switch result {
            case .success(let transactions):
                guard !transactions.isEmpty else {
                    print("Presenter success")
                    view?.showEmpty()
                    return
                }
                self.transactions = transactions
                self.view?.displayTransactions(transactions)
            case .failure(let error):
                print("Presenter fail")
                self.view?.showError(error)
            }
        }
    }
    
    func tapOnTheGroup(index: Int) {
        let group = transactions[index]
        router.openDetailModule(with: group)
    }
    
    func retryLoadingData() {
        viewDidLoad()
    }

}
