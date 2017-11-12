//
//  RoutePlanner.swift
//  Crawler
//
//  Created by Tom Pointon on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import Foundation
import CoreLocation

class RoutePlanner {
    
    // Track how many points we are looking up pubs for
    static var pointsFound = 0
    static var pointsProcessed = 0
    static var processBatchCount = 0
    static var userMaxPubs = 0
    static var pubs:[PubObject] = []
    static var batches:[Int:[PubObject]] = [:]
    static var closestDistances:[String:Double] = [:]
    
    //https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyCOYcJeQG_IG2HXw4BRehrnr2QPOCQYSzQ&origin=51.485411,-0.214231&destination=51.488990,-0.217742&mode=walking

    
    // Radius of each circle: half a mile
    // Step along the path in half a mile increments
    
    // We get a start and an end
    // We get the route between them from google
    // Which will be a polyline
    // We then step along the path in increments
    // For each point along the path
    // Get all the pubs in a radius
    // Determine the rating, and the distance from the pub
    // Add them to a queue of pubObjects
    
    // Gets the route between the start and end, in steps
    public class func getRouteBetweenStartEnd(start:CLLocation, end:CLLocation, maxPubs: Int, callback:@escaping (_ pubs: [PubObject]) -> Void) {
        
        // Initialise stuff
        pubs = []
        batches = [:]
        closestDistances = [:]
        userMaxPubs = 0
        processBatchCount = 0
        pointsProcessed = 0
        pointsFound = 0
        
        userMaxPubs = maxPubs
        
        let headers = [
            "content-type": "application/json"
        ]
        
        // TODO: take into account steps, to make the pub crawl more accurate
        let parameters:[String : Any] = [:]
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyCOYcJeQG_IG2HXw4BRehrnr2QPOCQYSzQ&origin=\(start.coordinate.latitude),\(start.coordinate.longitude)&destination=\(end.coordinate.latitude),\(end.coordinate.longitude)&mode=walking&units=imperial")! as URL,
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
                splitStepsUp(data: json, callback: callback)
            }
        }).resume()
        
    }
    
    // Splits all the line segments up into chunks of half a mile
    private class func splitStepsUp(data:JSON, callback:@escaping (_ pubs: [PubObject]) -> Void) {
        
        var routeChunks:[[CLLocation]] = []
        
        for leg in data["routes"][0]["legs"].array! {
            for step in leg["steps"].array! {
                routeChunks.append([CLLocation(latitude: step["start_location"]["lat"].double!, longitude: step["start_location"]["lng"].double!)])
            }
        }
        
        // Reduce the array of arrays
        var flattenedRouteChunks = routeChunks.reduce([], +)
        
        // Set how many points we have
        pointsFound = flattenedRouteChunks.count - 1
    
        // Get the pubs at each point
        for i in 1..<flattenedRouteChunks.count {
                getPubsPoint(loc: flattenedRouteChunks[i], prevLoc: flattenedRouteChunks[i - 1], callback: callback)
        }
        
    }
    
    // Takes a single step and splits it into chunks of a half a mile
//    private class func splitSingleStepUp(data: JSON) -> [CLLocation] {
//
//        // Get the distance that this segment takes up
//        let metersInHalfAMile = 804.672
//
//        // Calculate how many chunks we need to generate
//        let chunksNeeded = metersInHalfAMile/data["distance"]["value"].double!
//
//        // Calculate the ratio of the changes in latitude and longtidude
//        let dLat = (data["end_location"]["lat"].double! - data["start_location"]["lat"].double!)
//        let dLng = (data["end_location"]["lng"].double! - data["start_location"]["lng"].double!)
//        let magnitude = sqrt(pow(dLat, 2) + pow(dLng, 2))
//        let nLat = dLat / magnitude
//        let nLng = dLng / magnitude
//
//        var stepSegs:[CLLocation] = []
//        stepSegs.append(CLLocation(latitude: data["end_location"]["lat"].double!, longitude: data["start_location"]["lat"].double!))
//
//        for _ in 0..<Int(chunksNeeded) {
//            stepSegs.append(CLLocation(latitude: data["end_location"]["lat"].double! * nLat, longitude: data["end_location"]["lng"].double! * nLng))
//        }
//
//        return stepSegs
//    }
    
    private class func getPubsPoint(loc:CLLocation, prevLoc:CLLocation, callback:@escaping (_ pubs: [PubObject]) -> Void) {
        
        let headers = [
            "content-type": "application/json"
        ]
        
        let parameters:[String : Any] = [:]
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let requestString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAlecdJCO2kjIg48qjXL0NZ4SOztf1idLs&type=bar&location=\(loc.coordinate.latitude),\(loc.coordinate.longitude)&radius=804.672"
        let request = NSMutableURLRequest(url: NSURL(string: requestString)! as URL,
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
                batches[processBatchCount] = []
                for pub in json["results"].array! {
                    processPub(data: pub, currLoc: loc, prevLoc: prevLoc, batchNo: processBatchCount)
                }
                pointsProcessed += 1
                processBatchCount += 1
                
                print ("Points processed: \( pointsProcessed ) Points Found: \( pointsFound )")
                
                // If we have found all the pubs, filter the list and perform some ordering
                if (pointsFound == pointsProcessed) {
                    print ("Terminated")
                    DispatchQueue.main.async {
                        callback(cleanPubList())
                    }
                }
            }
        }).resume()

    }
    
    // Adds the pub to the list
    private class func processPub(data: JSON, currLoc: CLLocation, prevLoc: CLLocation, batchNo: Int) {
        
        // Create a new pub object
        let pubLoc = CLLocation(latitude: data["geometry"]["location"]["lat"].double!, longitude: data["geometry"]["location"]["lng"].double!)
        
        // co-ordinates of start and end point of line
        // co-ordinates of current point
        
        let distance = distanceFromLine(startPoint:prevLoc, endPoint: currLoc, pub: pubLoc)
        let pub = PubObject(id: 0, gmaps_id: data["id"].string!, name: data["name"].string!, location: pubLoc, photo_ref: data["photos"][0]["photo_reference"].string, rating: data["rating"].double, distance: distance)
        
        print("found pub \(pub.name!)")
        
        // Recording the lowest distance for each pub
        
        // If we have already found this pub, check the distance
        if let distance = closestDistances[pub.name!] {
            // If the distance we have before is greater than ours
            if distance > pub.distance! {
                // Remove the current value from the list
                closestDistances[pub.name!] = pub.distance!
            }
        } else {
            // Not found yet, so add to list
            closestDistances[pub.name!] = pub.distance!
        }
        
        
        // If closest to the last point we found, don't add it
        pub.distance = distance
        // If the distance is shorter than the previous one, add it
        // (Later, when traversing the list, just take the second one)
        batches[batchNo]!.append(pub)
        
    }
    
    // Distance from line
    private class func distanceFromLine(startPoint:CLLocation, endPoint: CLLocation, pub: CLLocation) -> Double {
        
        return abs((endPoint.coordinate.longitude - startPoint.coordinate.longitude) * pub.coordinate.latitude - ((endPoint.coordinate.latitude) - (startPoint.coordinate.latitude)) * pub.coordinate.longitude + (endPoint.coordinate.latitude) * (startPoint.coordinate.longitude) - endPoint.coordinate.longitude * startPoint.coordinate.latitude) / sqrt(pow(endPoint.coordinate.longitude - startPoint.coordinate.longitude, 2) + pow(endPoint.coordinate.latitude - startPoint.coordinate.latitude, 2))
        
    }
    
    // Calculates distance between two co-ordinates
    private class func distanceBetweenLocs(loc1:CLLocation, loc2:CLLocation) -> Double {
        
        let dLat = (loc2.coordinate.latitude - loc1.coordinate.latitude)
        let dLng = (loc2.coordinate.longitude - loc2.coordinate.longitude)
        return sqrt(pow(dLat, 2) + pow(dLng, 2))
        
    }
    
    // Sorts all the pubs by the batchNo
    // Removes the second
    private class func cleanPubList() -> [PubObject] {
    
        var pubsList:[[PubObject]] = []
        
        // Add the batches, in order, to the list
        for i in 0..<processBatchCount {
            pubsList.append(removeDuplicatePubs(pubs: batches[i]!))
        }
        
        // Flatten the list
        var flattenedPubsList = pubsList.reduce([], +)
        
        // Add the indexes
        for i in 0..<flattenedPubsList.count {
            flattenedPubsList[i].id = i
        }
        
        // Sort the array based on an object
        var sortedFlattenedPubsList = flattenedPubsList.sorted(by: { $0.distance < $1.distance })
        
        // Sort by the distance, take the amount the user wanted
        var sortedByDistancePubsList:[PubObject] = []
        for i in 0..<userMaxPubs {
            if i < flattenedPubsList.count {
                sortedByDistancePubsList.append(sortedFlattenedPubsList[i])
            }
        }
        
        // Sort by the original order
        var sortedByOriginalOrderPubs = flattenedPubsList.sorted(by: { $0.id < $1.id })
        
        // Re-write the indicies
        for i in 0..<sortedByOriginalOrderPubs.count {
            sortedByOriginalOrderPubs[i].id = i
        }
        
        print (closestDistances)
        
        return sortedByDistancePubsList
    }
    
    // Takes a list of pubs, cycles backwards and takes the second one if duplicates exist
    private class func removeDuplicatePubs(pubs:[PubObject]) -> [PubObject] {
    
        var result:[PubObject] = []
        var lastPubSeen:String = ""
        for i in 0..<pubs.count {
            let pub:PubObject = pubs[pubs.count - i - 1]
            if pub.name! != lastPubSeen {
                if closestDistances[pub.name!] == pub.distance! {
                    result.append(pub)
                }
                lastPubSeen = pub.name!
            }
        }
        
        return result
    }
    
}
