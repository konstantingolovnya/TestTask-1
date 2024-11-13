//
//  DetailModuleHeaderView.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import UIKit

final class DetailModuleHeaderView: UIView {
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.backgroundColor = UIColor.systemGray6
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTotal(_ total: String) {
        totalLabel.text = "Total: \(total)"
    }
}

private extension DetailModuleHeaderView {
    func setupSubviews() {
        addSubview(totalLabel)
        
        setupConstrains()
    }
    
    private func setupConstrains() {
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalLabel.topAnchor.constraint(equalTo: topAnchor),
            totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
