//
//  Pages+CoreDataProperties.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 1/6/19.
//  Copyright © 2019 Fabio Quintanilha. All rights reserved.
//
//

import Foundation
import CoreData


extension Pages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pages> {
        return NSFetchRequest<Pages>(entityName: "Pages")
    }

    @NSManaged public var note_image: Data?
    @NSManaged public var page_number: Int32
    @NSManaged public var notes: Notes?

}
