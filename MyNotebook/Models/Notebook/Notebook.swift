//
//  Notebook.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/28/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit

struct Notebook {
    
    var uid: String = ""
    var subject: String = ""
    var created_at: Date = Date()
    var notebookStye: UIImage!
    var notes = [Note]()
    
}
