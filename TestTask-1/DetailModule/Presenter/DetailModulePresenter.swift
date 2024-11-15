//
//  DetailModulePresenter.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation

protocol DetailModulePresenterProtocol {
    func viewDidLoad()
    var group: GroupOfTransactions { get }
    var title: String { get }
}

protocol DetailModuleViewProtocol: AnyObject {
    func displayTransactions(_ group: GroupOfTransactions)
    func showEmpty()
}

final class DetailModulePresenter: DetailModulePresenterProtocol {
    weak var view: DetailModuleViewProtocol?
    
    let group: GroupOfTransactions
    let title: String
        
    init(transaction: GroupOfTransactions) {
        self.group = transaction
        self.title = "Transactions for \(transaction.sku)"
    }
    
    func viewDidLoad() {
        if group.transactions.isEmpty {
            view?.showEmpty()
        }
        
        view?.displayTransactions(group)
    }
}
