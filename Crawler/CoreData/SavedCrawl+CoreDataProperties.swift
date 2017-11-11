//
//  SavedCrawl+CoreDataProperties.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedCrawl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedCrawl> {
        return NSFetchRequest<SavedCrawl>(entityName: "SavedCrawl")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var startLat: Double
    @NSManaged public var startLong: Double
    @NSManaged public var endLat: Double
    @NSManaged public var endLong: Double
    @NSManaged public var pubs: NSSet?

}

// MARK: Generated accessors for pubs
extension SavedCrawl {

    @objc(addPubsObject:)
    @NSManaged public func addToPubs(_ value: Pub)

    @objc(removePubsObject:)
    @NSManaged public func removeFromPubs(_ value: Pub)

    @objc(addPubs:)
    @NSManaged public func addToPubs(_ values: NSSet)

    @objc(removePubs:)
    @NSManaged public func removeFromPubs(_ values: NSSet)

}
