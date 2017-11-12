//
//  Math.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import Foundation


public func distFrom(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
    
    let earthRadius = 6371000.0
    let dLat = degreesToRads(deg: (lat2 - lat1))
    let dLng = degreesToRads(deg: (lng2 - lng1))
    let a = sin(dLat / 2) * sin(dLat / 2) + cos(degreesToRads(deg: lat1)) * cos(degreesToRads(deg: lat2)) * sin(dLng / 2) * sin(dLng / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))
    let dist = earthRadius * c
    
    return dist
    
}

public func degreesToRads(deg: Double) -> Double {
    return deg / 180 * Double.pi
}

