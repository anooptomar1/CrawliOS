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
    
    var id:String!
    var name:String!
    var location:CLLocation!
    var rating:Double?
    
    init(id:String, name:String, location:CLLocation, rating:Double?) {
        self.id = id
        self.name = name
        self.location = location
        self.rating = rating
    }
    
}
