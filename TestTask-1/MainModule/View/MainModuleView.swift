//
//  MainModuleView.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import UIKit

final class MainModuleView: UIView {
    private var transactions: [GroupOfTransactions]?
    private let presenter: MainModulePresenterProtocol
    
    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Data not found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.isHidden = true
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try again", for: .normal)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    
    private lazy var errorStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalCentering
        view.isHidden = true
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
    
    func update(transactions: [GroupOfTransactions]) {
        self.transactions = transactions
        tableView.reloadData()
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    func showEmpty() {
        emptyDataLabel.isHidden = false
    }
    
    func showError(_ error: Error) {
        errorLabel.text = "Error loading products, please try again"
        errorStack.isHidden = false
    }
    
    @objc private func retryButtonTapped() {
        presenter.retryLoadingData()
        errorStack.isHidden = true
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
        cell.configure(titleText: transaction.sku, count: "\(transaction.transactions.count) transactions", showsDisclosureIndicator: true)
        return cell
    }
}

extension MainModuleView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tapOnTheGroup(index: indexPath.row)
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
        addSubview(emptyDataLabel)
        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)
        addSubview(errorStack)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        emptyDataLabel.translatesAutoresizingMaskIntoConstraints = false
        errorStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            emptyDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyDataLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

