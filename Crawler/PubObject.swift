//
//  PubObject.swift
//  Crawler
//
//  Created by Tom Pointon on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import Foundation
import CoreLocation

// Stores the pub information we get from the Google API
class PubObject {
    
    var id:Int!
    var gmaps_id:String!
    var name:String!
    var location:CLLocation!
    var photo_ref:String?
    var distance:Double!
    var rating:Double?
    
    init(id:Int, gmaps_id:String, name:String, location:CLLocation, photo_ref:String?, rating:Double?, distance:Double) {
        self.id = id
        self.gmaps_id = gmaps_id
        self.name = name
        self.location = location
        self.distance = distance
        self.rating = rating
        self.photo_ref = photo_ref
    }
    
}
