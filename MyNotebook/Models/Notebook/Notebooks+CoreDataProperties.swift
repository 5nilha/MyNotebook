//
//  Notebooks+CoreDataProperties.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 1/6/19.
//  Copyright © 2019 Fabio Quintanilha. All rights reserved.
//
//

import Foundation
import CoreData


extension Notebooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notebooks> {
        return NSFetchRequest<Notebooks>(entityName: "Notebooks")
    }

    @NSManaged public var cover: Data?
    @NSManaged public var created_at: Date?
    @NSManaged public var notebook_uid: String?
    @NSManaged public var number_of_pages: Int32
    @NSManaged public var subject: String?
    @NSManaged public var notes: NSOrderedSet?

}

// MARK: Generated accessors for notes
extension Notebooks {

    @objc(insertObject:inNotesAtIndex:)
    @NSManaged public func insertIntoNotes(_ value: Notes, at idx: Int)

    @objc(removeObjectFromNotesAtIndex:)
    @NSManaged public func removeFromNotes(at idx: Int)

    @objc(insertNotes:atIndexes:)
    @NSManaged public func insertIntoNotes(_ values: [Notes], at indexes: NSIndexSet)

    @objc(removeNotesAtIndexes:)
    @NSManaged public func removeFromNotes(at indexes: NSIndexSet)

    @objc(replaceObjectInNotesAtIndex:withObject:)
    @NSManaged public func replaceNotes(at idx: Int, with value: Notes)

    @objc(replaceNotesAtIndexes:withNotes:)
    @NSManaged public func replaceNotes(at indexes: NSIndexSet, with values: [Notes])

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Notes)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Notes)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSOrderedSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSOrderedSet)

}
