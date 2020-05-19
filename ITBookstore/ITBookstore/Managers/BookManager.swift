//
//  BookManager.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import UIKit

public class BookManager {
    private var bookImages: [String:UIImage] = [:]
    
    private let bookService: BookService
    
    public func loadBooks(completion: @escaping ([Book]) -> Void) {
        bookService.searchBooks(for: "swift") { (result) in
            var books: [Book] = []
            switch result {
            case let .success(fetchedBooks):
                books = fetchedBooks
            case let .failure(error):
                print("Book list retrieval failed: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(books)
            }
        }
    }
    
    public func loadImage(book: Book, completion: @escaping (UIImage) -> Void) {
        let placeholderImage = UIImage(systemName: "questionmark.square")!
        let grayPlaceholderImage = placeholderImage.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        var image = grayPlaceholderImage
        
        if bookImages.keys.contains(book.isbn13) {
            image = bookImages[book.isbn13]!
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        guard let imageURL = URL(string: book.image) else {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        bookService.fetchImage(url: imageURL) { (result) in
            switch result {
            case let .success(fetchedImage):
                image = fetchedImage
                self.bookImages[book.isbn13] = image
            case let .failure(error):
                print("Image retrieval failed: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    init(bookService: BookService) {
        self.bookService = bookService
    }
}
