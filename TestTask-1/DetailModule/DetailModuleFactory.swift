//
//  DetailModuleFactory.swift
//  TestTask-1
//
//  Created by Konstantin on 12.11.2024.
//

import Foundation
import UIKit

protocol DetailModuleFactoryProtocol {
    func makeDetailModuleViewController(transaction: Transaction, rates: [CurrencyRate]) -> DetailModuleViewController }

final class DetailModuleFactory: DetailModuleFactoryProtocol {
    func makeDetailModuleViewController(transaction: Transaction, rates: [CurrencyRate]) -> DetailModuleViewController {
        let converter = CurrencyConverter(rates: rates)
        let formatter = CurrencyFormatter()
        
        let presenter = DetailModulePresenter(transaction: transaction, converter: converter, formatter: formatter)
        let detailModuleVC = DetailModuleViewController(presenter: presenter)
        
        presenter.view = detailModuleVC
        return detailModuleVC
    }
}
