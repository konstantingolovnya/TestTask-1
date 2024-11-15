//
//  MainModuleTableViewCell.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import UIKit

final class ReusableTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
        selectionStyle = .none
        tintColor = .red
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(titleText: String, count: String, showsDisclosureIndicator: Bool) {
        titleLabel.text = titleText
        bodyLabel.text = count
        accessoryType = showsDisclosureIndicator ? .disclosureIndicator : .none
    }
}

private extension ReusableTableViewCell {
    func setupSubviews() {
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(bodyLabel)
        contentView.addSubview(stack)
        setupConstrains()
    }
    
    func setupConstrains() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
