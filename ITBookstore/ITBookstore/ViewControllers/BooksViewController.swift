//
//  ViewController.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {
    var bookManager: BookManager?
    
    private let dataSource = BooksTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        load()
    }
    
    private func load() {
        bookManager?.loadBooks(completion: { (books) in
            self.dataSource.books = books
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showBookDetail":
            if let selectedIndexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? BookDetailViewController {
                
                let book = dataSource.books[selectedIndexPath.row]
                destinationVC.bookManager = bookManager
                destinationVC.book = book
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let book = self.dataSource.books[indexPath.row]
        
        bookManager?.loadImage(for: book, completion: { (image) in
            cell.imageView?.image = image
        })
    }

}

