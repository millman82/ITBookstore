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
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var price: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = book?.title
        
        if let bookManager = bookManager, let book = book {
            bookManager.loadImage(book: book) { (image) in
                self.coverImage.image = image
            }
        }
        
        bookTitle.text = book?.title
        subtitle.text = book?.subtitle
        isbn.text = book?.isbn13
        price.text = book?.price
    }
}
