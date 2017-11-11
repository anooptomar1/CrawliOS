//
//  Pub+CoreDataProperties.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//
//

import Foundation
import CoreData


extension Pub {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pub> {
        return NSFetchRequest<Pub>(entityName: "Pub")
    }

    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var id: Int64
    @NSManaged public var crawl: SavedCrawl?

}
