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
        let dataProvider =  DataProvider()
        
        let router: MainModuleRouterProtocol = {
            let router = MainModuleRouter(detailModuleFactory: DetailModuleFactory())
            return router
        }()
        
        let presenter = MainModulePresenter(dataService: dataService, dataProvider: dataProvider, router: router)
        let mainModuleVC = MainModuleViewController(presenter: presenter)
        presenter.view = mainModuleVC
        router.setRootViewController(root: mainModuleVC)
        return mainModuleVC
    }
}
