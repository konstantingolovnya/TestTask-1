//
//  DataService.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol DataServiceProtocol {
    func loadPlist<T: Decodable>(named name: String, completion: @escaping (Result<[T], Error>) -> ())
}

final class DataService: DataServiceProtocol {
    
    func loadPlist<T: Decodable>(named name: String, completion: @escaping (Result<[T], Error>) -> ()) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "plist") else { return }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            do {
                let data = try Data(contentsOf: url)
                let dataModels = try PropertyListDecoder().decode([T].self, from: data)
                completion(.success(dataModels))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
