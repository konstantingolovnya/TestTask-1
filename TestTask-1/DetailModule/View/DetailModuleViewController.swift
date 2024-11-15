//
//  File.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation
import UIKit

final class DetailModuleViewController: UIViewController {
    private let presenter: DetailModulePresenterProtocol
    private lazy var detailView = DetailModuleView(presenter: presenter)
    
    init(presenter: DetailModulePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        view.backgroundColor = UIColor.systemGray6
        presenter.viewDidLoad()
    }
}

extension DetailModuleViewController: DetailModuleViewProtocol {
    func displayTransactions(_ group: GroupOfTransactions) {
        detailView.update(group: group)
    }
    
    func showEmpty() {
        detailView.showEmpty()
    }
}
