//
//  BookDetailViewController.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    var bookManager: BookManager?
    var book: Book?
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var pages: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var price: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = book?.title
        
        if let bookManager = bookManager, let book = book {
            bookManager.loadImage(for: book) { (image) in
                self.coverImage.image = image
            }
            
            bookManager.loadBookDetail(for: book) {
                self.bookDescription.text = self.book?.desc
                self.authors.text = self.book?.authors
                self.publisher.text = self.book?.publisher
                
                if let pageCount = self.book?.pages {
                    self.pages.text = String(describing: pageCount)
                } else {
                    self.pages.text = ""
                }
                
                if let publishYear = self.book?.year {
                    self.year.text = String(describing: publishYear)
                } else {
                    self.year.text = ""
                }
            }
        }
        
        bookTitle.text = book?.title
        subtitle.text = book?.subtitle
        isbn.text = book?.isbn13
        price.text = book?.price
    }
}
