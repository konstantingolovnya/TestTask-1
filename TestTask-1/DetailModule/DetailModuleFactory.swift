//
//  DetailModuleFactory.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation
import UIKit

protocol DetailModuleFactoryProtocol {
    func makeDetailModuleViewController(transaction: GroupOfTransactions) -> DetailModuleViewController }

final class DetailModuleFactory: DetailModuleFactoryProtocol {
    func makeDetailModuleViewController(transaction: GroupOfTransactions) -> DetailModuleViewController {
        
        let presenter = DetailModulePresenter(transaction: transaction)
        let detailModuleVC = DetailModuleViewController(presenter: presenter)
        
        presenter.view = detailModuleVC
        return detailModuleVC
    }
}
