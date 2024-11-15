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
    
    private var group: GroupOfTransactions?
    
    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Data not found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.isHidden = true
        return label
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
    
    func update(group: GroupOfTransactions) {
        self.group = group
        headerView.updateTotal(group.formattedAmount)
        tableView.reloadData()
    }
    
    func showEmpty() {
        emptyDataLabel.isHidden = false
    }
}

extension DetailModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group, let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReusableTableViewCell.self)) as? ReusableTableViewCell else {
            return UITableViewCell()
        }
        
        let transaction = group.transactions[indexPath.row]
        cell.configure(titleText: transaction.formattedAmount, count: transaction.formattedAmountInTargetCurrency, showsDisclosureIndicator: false)
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
        addSubview(emptyDataLabel)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            emptyDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyDataLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

