//
//  Note.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/25/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit

class Note {
    
    var title: String = ""
    var date: Date! = Date()
    var pageNumber: Int = 0
    var noteImage: UIImage!
    var notePages = [UIImage]()
    
    init (title: String, date: Date, pageNumber: Int) {
        self.title = title
        self.date = date
        self.pageNumber = pageNumber
    }
    
}
