//
//  MainModuleView.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import UIKit

final class DetailModuleView: UIView {
    private let presenter: DetailModulePresenterProtocol
    private let headerView = DetailModuleHeaderView()
    
    private var model: Model!
    
    struct Model {
        let total: String
        let transactions: [FormattedTransaction]
        
        struct FormattedTransaction {
            let amountInOriginalCurrency: String
            let amountInTargetCurrency: String
        }
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ReusableTableViewCell.self, forCellReuseIdentifier: String(describing: ReusableTableViewCell.self))
        view.headerView(forSection: 0)?.tintColor = UIColor.black
        view.backgroundColor = .systemBackground
        view.separatorStyle = .singleLine
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 80
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        return view
    }()
    
    init(presenter: DetailModulePresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: DetailModuleView.Model) {
        self.model = model
        headerView.updateTotal(self.model.total)
        tableView.reloadData()
    }
}

extension DetailModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReusableTableViewCell.self)) as? ReusableTableViewCell else {
            return UITableViewCell()
        }
        
        let transaction = model.transactions[indexPath.row]
        cell.update(titleText: transaction.amountInOriginalCurrency, count: transaction.amountInTargetCurrency)
        return cell
    }
}

private extension DetailModuleView {
    func commonInit() {
        backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(headerView)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                    headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                    headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    headerView.trailingAnchor.constraint(equalTo: trailingAnchor),

                    tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                    tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
                ])
    }
}

