//
//  Notebook.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/28/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit
import CoreData


struct Notebook {
    
    var object: Notebooks!
    var uid: String = ""
    var subject: String = ""
    var created_at: Date = Date()
    var notebookStye = UIImage(named: "notebook_black")
    var notes = [Note]()
    
}
