//
//  DataService.swift
//  TestTask-1
//
//  Created by Konstantin on 11.11.2024.
//

import Foundation

protocol DataServiceProtocol {
    func loadPlist<T: Decodable>(named name: String, completion: @escaping (Result<[T], Error>) -> Void)
}

enum DataServiceError: Error {
    case fileNotFound(name: String)
}

final class DataService: DataServiceProtocol {
    
    func loadPlist<T: Decodable>(named name: String, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "plist") else {
            let error = NSError(
                domain: "TestTask-1.DataService", 
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Plist file '\(name)' not found"]
            )
            completion(.failure(error))
            return
        }
        
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
