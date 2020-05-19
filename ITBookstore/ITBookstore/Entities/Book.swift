//
//  Book.swift
//  ITBookstore
//
//  Created by Timothy Miller on 5/18/20.
//  Copyright © 2020 Timothy Miller. All rights reserved.
//

import Foundation

public class Book: Decodable {
    let title: String
    let subtitle: String
    var authors: String?
    var publisher: String?
    let isbn13: String
    var pages: String?
    var year: String?
    var rating: String?
    var desc: String?
    let price: String
    let image: String
    let url: String
}
