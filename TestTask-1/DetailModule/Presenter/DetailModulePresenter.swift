//
//  DetailModulePresenter.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation

protocol DetailModulePresenterProtocol {
    var group: GroupOfTransactions { get }
    var title: String { get }
    
    func viewDidLoad()
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
        guard !group.transactions.isEmpty else {
            view?.showEmpty()
            return
        }
        
        view?.displayTransactions(group)
    }
}
