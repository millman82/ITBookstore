//
//  BookService.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import Foundation

public enum BookServiceError: Error {
    case invalidJSONData
    case requestFailed
}

public struct BookService {
    private let rootUrl = "https://api.itbook.store/1.0"
    
    func searchBooks(for query: String, completion: @escaping (Result<[Book], BookServiceError>) -> Void) {
        let searchPath = "/search/\(query)"
        
        guard let queryURL = URL(string: "\(rootUrl)\(searchPath)") else {
            completion(.failure(.requestFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: queryURL) { (data, respnose, error) in
            guard let data = data else {
                if let error = error {
                    print("Book query failed \(error)")
                }
                
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                // Only concerned with first page of results for now so grabbing the books array direct from response
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard
                    let jsonDictionary = jsonObject as? [String:Any],
                    let bookJSON = jsonDictionary["books"] as? [Any] else {
                        completion(.failure(.invalidJSONData))
                        return
                }
                
                let booksData = try JSONSerialization.data(withJSONObject: bookJSON, options: [])
                let jsonDecoder = JSONDecoder()
                let books = try jsonDecoder.decode([Book].self, from: booksData)
                completion(.success(books))
            } catch {
                print("Error deserializing books json")
                completion(.failure(.invalidJSONData))
            }
        }
        
        task.resume()
    }
}
