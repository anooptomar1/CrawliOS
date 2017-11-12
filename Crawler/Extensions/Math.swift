//
//  Math.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import Foundation

let otherLat = 46.519581
let otherLong = 6.561847

let ourLat = 46.518591
let ourLong = 6.562105

public func distFrom(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
    
    let earthRadius = 6371000.0
    let dLat = degreesToRads(deg: (lat2 - lat1))
    let dLng = degreesToRads(deg: (lng2 - lng1))
    let a = sin(dLat / 2) * sin(dLat / 2) + cos(degreesToRads(deg: lat1)) * cos(degreesToRads(deg: lat2)) * sin(dLng / 2) * sin(dLng / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))
    let dist = earthRadius * c
    
    return dist
    
}

public func bearingFrom(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
    
    let y = sin(lng2 - lng1) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lng2 - lng1)
    let bearing = atan2(y, x)
    
    return bearing
    
}

public func degreesToRads(deg: Double) -> Double {
    return deg / 180 * Double.pi
}

