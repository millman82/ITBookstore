//
//  ViewController.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {
    var bookService: BookService?
    
    private var dataSource = BooksTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        load()
    }
    
    private func load() {
        bookService?.searchBooks(for: "swift", completion: { (result) in
            switch result {
            case let .success(books):
                self.dataSource.books = books
            case let .failure(error):
                print(error)
                self.dataSource.books = []
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

}

