//
//  LocationPickerViewController.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationPickerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mapHolder: UIView!
    @IBOutlet weak var pinImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    
    var returnCoordinate: CLLocationCoordinate2D!
    
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer.shadowPath = CGPath(roundedRect: headerView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        headerView.clipsToBounds = false
        headerView.layer.shadowColor = shadowColor.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowRadius = 10
        headerView.layer.shadowOpacity = 1
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        moveToCurrentLocation()
    }
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        
        returnCoordinate = mapView!.camera.target
        
        self.performSegue(withIdentifier: "unwindLocation", sender: nil)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            currentLocation = locations.first!
            
            if mapView == nil {
            
            DispatchQueue.main.async {
                
                let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude, zoom: 13)
                self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapHolder.frame.size.width, height: self.mapHolder.frame.size.height), camera: camera)
                self.mapView!.mapType = .normal
                
                
                self.mapHolder.addSubview(self.mapView!)
                self.mapHolder.bringSubview(toFront: self.pinImageView)
                }
            }
        }
    }
    
    func moveToCurrentLocation() {
        
        let update = GMSCameraUpdate.setTarget(self.currentLocation.coordinate, zoom: 13)
        
        mapView?.moveCamera(update)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location - \(error.localizedDescription)")
    }
}
