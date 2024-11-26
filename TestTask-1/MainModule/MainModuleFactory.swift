//
//  DependencyFactory.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation
import UIKit

protocol MainModuleFactoryProtocol {
    func makeMainModileViewController() -> MainModuleViewController
}

final class MainModuleFactory: MainModuleFactoryProtocol {
    
    func makeMainModileViewController() -> MainModuleViewController {
        let dataService = DataService()
        let converter = CurrencyConverter()
        let formatter = CurrencyFormatter()
        let dataProvider = DataProvider(dataService: dataService, converter: converter, formatter: formatter)
        
        let router = MainModuleRouter(detailModuleFactory: DetailModuleFactory())
        let presenter = MainModulePresenter(dataProvider: dataProvider, router: router)
        let mainModuleVC = MainModuleViewController(presenter: presenter)
        presenter.view = mainModuleVC
        router.setRootViewController(root: mainModuleVC)
        return mainModuleVC
    }
}
