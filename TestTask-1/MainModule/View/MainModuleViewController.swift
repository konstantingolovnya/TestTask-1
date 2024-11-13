//
//  MainModuleViewController.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import UIKit

final class MainModuleViewController: UIViewController {
    var presenter: MainModulePresenterProtocol
    private lazy var mainModuleView = MainModuleView(presenter: presenter)
    
    init(presenter: MainModulePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainModuleView
    }
    
    override func viewDidLoad() {
        startSpinner()
        title = presenter.title
        view.backgroundColor = UIColor.systemGray6
        navigationController?.navigationBar.prefersLargeTitles = false
        presenter.loadProducts()
    }
}

extension MainModuleViewController: MainViewProtocol {
    func displayTransactions(_ transactions: [Transaction]) {
        mainModuleView.update(transactions: transactions)
    }
    
    func startSpinner() {
        mainModuleView.startSpinner()
    }
    
    func stopSpinner() {
        mainModuleView.stopSpinner()
    }
    
    func showError(_ error: Error) {
        mainModuleView.showError(error)
    }
}
