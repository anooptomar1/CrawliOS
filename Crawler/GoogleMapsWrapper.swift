//
//  GoogleMapsWrapper.swift
//  Crawler
//
//  Created by Tom Pointon on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleMapsWrapper {
    
    // Queries the Maps API for pubs near me
    public class func GetPubs(myLocation: CLLocation, maxCount: Int, callback:@escaping (_ pubs: [PubObject]) -> Void) {
        
        print("IN FUNC")
        
        let headers = [
            "content-type": "application/json"
        ]
        let parameters:[String : Any] = [:]
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAlecdJCO2kjIg48qjXL0NZ4SOztf1idLs&location=\(myLocation.coordinate.latitude),\(myLocation.coordinate.longitude)&rankby=distance&type=bar")! as URL,
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
                
                DispatchQueue.main.async {
                    callback([])
                }
                
            } else {
                print("HTTP SUCCESS")
                // let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String!
                let json = try! JSON(data: data!)
                
                // Strip out the relavant bits
                var results:[PubObject] = []
                for result in json["results"].array! {
                    let location = CLLocation(latitude: result["geometry"]["location"]["lat"].double!, longitude: result["geometry"]["location"]["lng"].double!)
                    results.append(PubObject(id:result["id"].string!, name:result["name"].string!, location:location, rating:result["rating"].double!))
                }
                DispatchQueue.main.async {
                    callback(results)
                }
                
                
            }
        }).resume()
        
    }

    
}
