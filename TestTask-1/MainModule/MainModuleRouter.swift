//
//  MainModuleRouter.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation
import UIKit

protocol MainModuleRouterProtocol {
    func openDetailModule(with transaction: GroupOfTransactions)
    func setRootViewController(root: UIViewController)
}

final class MainModuleRouter: MainModuleRouterProtocol {
    private let detailModuleFactory: DetailModuleFactoryProtocol
    private weak var root: UIViewController?
    
    init(detailModuleFactory: DetailModuleFactoryProtocol) {
        self.detailModuleFactory = detailModuleFactory
    }
    
    func setRootViewController(root: UIViewController) {
        self.root = root
    }
    
    func openDetailModule(with transaction: GroupOfTransactions) {
        let viewController = detailModuleFactory.makeDetailModuleViewController(transaction: transaction)
        
        root?.navigationController?.pushViewController(viewController, animated: true)
    }
}
