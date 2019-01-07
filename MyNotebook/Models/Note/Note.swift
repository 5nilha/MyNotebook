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
    
    var noteObject: Notes!
    var title: String = ""
    var created_at: Date! = Date()
    var noteImage: UIImage!
    var notePages = [Int32 : Page]()
    
    init (title: String, created_at: Date) {
        self.title = title
        self.created_at = created_at
    }
    
    func getNumberOfPages() -> Int32{
        let count = Int32(self.notePages.count)
        return count
    }
    
    
    func saveNote(to notebook: Notebook) {
        DataService.shared.saveNewNote(note: self, notebook: notebook)
    }
    
}
