//
//  BookService.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import UIKit

public enum BookServiceError: Error {
    case detailRequestFailed
    case imageRequestFailed
    case invalidJSONData
    case invalidImageData
    case requestFailed
}

public struct BookService {
    private let rootUrl = "https://api.itbook.store/1.0"
    
    public func searchBooks(for query: String, completion: @escaping (Result<[Book], BookServiceError>) -> Void) {
        let searchPath = "/search/\(query)"
        
        guard let queryURL = URL(string: "\(rootUrl)\(searchPath)") else {
            completion(.failure(.requestFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: queryURL) { (data, _, error) in
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
    
    public func fetchImage(url: URL, completion: @escaping (Result<UIImage, BookServiceError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                if let error = error {
                    print("Image retrieval failed \(error)")
                }
                
                completion(.failure(.imageRequestFailed))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(.invalidImageData))
            }
        }
        
        task.resume()
    }
    
    public func fetchBookDetail(for book: Book, completion: @escaping (Result<Book, BookServiceError>) -> Void) {
        let queryPath = "/books/\(book.isbn13)"
        
        guard let detailQueryURL = URL(string: "\(rootUrl)\(queryPath)") else {
            completion(.failure(.detailRequestFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: detailQueryURL) { (data, _, error) in
            guard let data = data else {
                if let error = error {
                    print("Book detail retrieval failed \(error)")
                }
                
                completion(.failure(.detailRequestFailed))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let bookDetail = try jsonDecoder.decode(Book.self, from: data)
                completion(.success(bookDetail))
            } catch {
                print("Error deserializing book json")
                completion(.failure(.invalidJSONData))
            }
        }
        
        task.resume()
    }
}
