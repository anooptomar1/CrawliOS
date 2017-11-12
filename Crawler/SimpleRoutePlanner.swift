//
//  SimpleRoutePlanner.swift
//  Crawler
//
//  Created by Tom Pointon on 12/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import Foundation
import CoreLocation

class SimpleRoutePlanner {
    
    // From the starting location
    // Get all the pubs within half a mile
    // Sort them by their distance to the destination
    // Pick the closest one
    // Add it to our route
    // Recurse until we are at our stop
    
    static var end = CLLocation()
    static var pubsFound:[PubObject] = []
    static var pubsId = 0
    static var visitedPubs:[String:Bool] = [:]
    
    public class func getRoute(start:CLLocation, end:CLLocation, maxPubs: Int, callback:@escaping (_ pubs: [PubObject]) -> Void) {
        self.end = end
        self.pubsFound = []
        self.pubsId = 0
        self.visitedPubs = [:]
    
        // Get pubs with half a mile
        
        queryPubsWithinRange(currLoc: start, radius: 300) { (pubs) in
            
            var indexesSeen: [UInt32] = []
            
            var newPubs:[PubObject] = []
            
            var counter = 0
            
            
            while counter < min(maxPubs, pubs.count) {
                let randVal = arc4random_uniform(UInt32(pubs.count))
                
                if indexesSeen.contains(randVal) {
                    continue
                }
                
                indexesSeen.append(randVal)
                newPubs.append(pubs[Int(randVal)])
                counter += 1
                
            }
            
            
            //a
            
            callback(newPubs)
        }
        
    }
    
    private class func queryPubsWithinRange(currLoc: CLLocation, radius: Int, callback:@escaping (_ pubs: [PubObject]) -> Void) {
        
        // Query for pubs within half a mile
        let headers = [
            "content-type": "application/json"
        ]
        
        let parameters:[String : Any] = [:]
        let query = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAlecdJCO2kjIg48qjXL0NZ4SOztf1idLs&type=bar&location=\(currLoc.coordinate.latitude),\(currLoc.coordinate.longitude)&radius=\(radius)&units=metric"
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: query)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("HTTP FAIL")
                print(error!.localizedDescription)
            } else {
                let json = try! JSON(data: data!)
                choosePub(data: json, radius: radius, callback: callback)
            }
        }).resume()
        
    }
    
    private class func choosePub(data:JSON, radius:Int, callback:@escaping (_ pubs: [PubObject]) -> Void) {
    
        var bestPubObj:JSON = JSON()
        var pubLoc = CLLocation()
        var leastDistanceToEnd:Double = 100000000000000.0
        for pub in data["results"].array! {
            let potentialPubLoc = CLLocation(latitude: pub["geometry"]["location"]["lat"].double!, longitude: pub["geometry"]["location"]["lng"].double!)
            let distanceToEnd = distFrom(lat1: potentialPubLoc.coordinate.latitude, lng1: potentialPubLoc.coordinate.longitude, lat2: self.end.coordinate.latitude, lng2: self.end.coordinate.longitude)
            
            if (leastDistanceToEnd > distanceToEnd) {
                leastDistanceToEnd = distanceToEnd
                bestPubObj = pub
                pubLoc = potentialPubLoc
            }
        }
        
        print(leastDistanceToEnd)
        
        // Add the pub to the array
        let actualPubObj = PubObject(id: self.pubsId, gmaps_id: bestPubObj["id"].string!, name: bestPubObj["name"].string!, location: pubLoc, photo_ref: bestPubObj["photos"][0]["photo_reference"].string, rating: bestPubObj["rating"].double, distance: leastDistanceToEnd)
        
        if let _ = visitedPubs[actualPubObj.name] {
            queryPubsWithinRange(currLoc: pubLoc, radius: radius * 2, callback: callback)
            return
        }
        
        pubsFound.append(actualPubObj)
        visitedPubs[actualPubObj.name!] = true
        self.pubsId += 1
    
        
        // Check that the distance to the end is less than 500 meters
        print (leastDistanceToEnd)
        if leastDistanceToEnd < 500 {
            // Terminate using the callback
            DispatchQueue.main.async {
                callback(self.pubsFound)
            }
            return
        }
        
        // Otherwise recurse, using the new pub
        queryPubsWithinRange(currLoc: pubLoc, radius: radius, callback: callback)
        
    }
    
    private class func toRadians(n:Double) -> Double {
        
        return (180.0 * n) / 3.14159265359
        
    }

    
}
