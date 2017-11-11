//
//  ViewController.swift
//  Crawl
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class CrawlsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let shadowColor = UIColor.colorWithHsb(0, s: 0, b: 39, a: 0.5)
    let shadowColorLight = UIColor.colorWithHsb(0, s: 0, b: 39, a: 0.3)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
        
    }

    @IBOutlet weak var headerView: UIView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer.shadowPath = CGPath(roundedRect: headerView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        headerView.clipsToBounds = false
        headerView.layer.shadowColor = shadowColor.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowRadius = 10
        headerView.layer.shadowOpacity = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var crawlFetchedResultsController : NSFetchedResultsController<SavedCrawl> = {
        
        let fetchRequest:NSFetchRequest<SavedCrawl> = SavedCrawl.fetchRequest()
        
        let primarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        fetchRequest.fetchBatchSize = 20
        
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        aFetchedResultsController.delegate = self
        
        return aFetchedResultsController
    }()

}


extension CrawlsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crawlCell", for: indexPath) as! CrawlTableViewCell
        
        cell.cellView.layer.shadowPath = CGPath(roundedRect: cell.cellView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        cell.clipsToBounds = false
        cell.cellView.clipsToBounds = false
        cell.cellView.layer.shadowColor = shadowColorLight.cgColor
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cellView.layer.shadowRadius = 10
        cell.cellView.layer.shadowOpacity = 1
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                              longitude: 151.2086,
                                              zoom: 14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
        cell.mapHolder.addSubview(mapView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 316
    }
}
