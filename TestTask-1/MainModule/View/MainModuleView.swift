//
//  MainModuleView.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import UIKit

final class MainModuleView: UIView {
    private var transactions: [Transaction]?
    private let presenter: MainModulePresenterProtocol
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ReusableTableViewCell.self, forCellReuseIdentifier: String(describing: ReusableTableViewCell.self))
        view.backgroundColor = .systemBackground
        view.separatorStyle = .singleLine
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 80
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
    
    init(presenter: MainModulePresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(transactions: [Transaction]) {
        self.transactions = transactions
        tableView.reloadData()
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    func showError(_ error: Error) {
        print(error)
    }
}

extension MainModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transactions = transactions, let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReusableTableViewCell.self)) as? ReusableTableViewCell else {
            return UITableViewCell()
        }
        
        let transaction = transactions[indexPath.row]
        cell.update(titleText: transaction.sku, count: "\(transaction.transactions.count) transactions")
        return cell
    }
}

extension MainModuleView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tapOnTheTransaction(index: indexPath.row)
    }
}

private extension MainModuleView {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
        addSubview(spinner)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor), //20
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor), // -20
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

