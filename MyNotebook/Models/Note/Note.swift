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
    
    var subject_uid: String = ""
    var subject: String = ""
    var title: String = ""
    var date: Date! = Date()
    var noteImage: UIImage!
    var notePages = [Int : Page]()
    
    init (subject_uid: String, subject: String, title: String, date: Date) {
        self.subject_uid = subject_uid
        self.subject = subject
        self.title = title
        self.date = date
    }
    
    func getNumberOfPages() -> Int {
        return self.notePages.count
    }
    
}
