//
//  Notes+CoreDataProperties.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 1/6/19.
//  Copyright © 2019 Fabio Quintanilha. All rights reserved.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var info: String?
    @NSManaged public var is_bookmarked: Bool
    @NSManaged public var note_uid: String?
    @NSManaged public var number_of_pages: Int32
    @NSManaged public var title: String?
    @NSManaged public var notebooks: Notebooks?
    @NSManaged public var pages: NSOrderedSet?

}

// MARK: Generated accessors for pages
extension Notes {

    @objc(insertObject:inPagesAtIndex:)
    @NSManaged public func insertIntoPages(_ value: Pages, at idx: Int)

    @objc(removeObjectFromPagesAtIndex:)
    @NSManaged public func removeFromPages(at idx: Int)

    @objc(insertPages:atIndexes:)
    @NSManaged public func insertIntoPages(_ values: [Pages], at indexes: NSIndexSet)

    @objc(removePagesAtIndexes:)
    @NSManaged public func removeFromPages(at indexes: NSIndexSet)

    @objc(replaceObjectInPagesAtIndex:withObject:)
    @NSManaged public func replacePages(at idx: Int, with value: Pages)

    @objc(replacePagesAtIndexes:withPages:)
    @NSManaged public func replacePages(at indexes: NSIndexSet, with values: [Pages])

    @objc(addPagesObject:)
    @NSManaged public func addToPages(_ value: Pages)

    @objc(removePagesObject:)
    @NSManaged public func removeFromPages(_ value: Pages)

    @objc(addPages:)
    @NSManaged public func addToPages(_ values: NSOrderedSet)

    @objc(removePages:)
    @NSManaged public func removeFromPages(_ values: NSOrderedSet)

}
