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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
        
    }
    
    @IBOutlet weak var headerView: UIView!
    
    var crawlForPassing: SavedCrawl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        headerView.layer.shadowPath = CGPath(roundedRect: headerView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        headerView.clipsToBounds = false
        headerView.layer.shadowColor = shadowColor.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowRadius = 10
        headerView.layer.shadowOpacity = 1
        
        try! crawlFetchedResultsController.performFetch()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentCreateForm", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentCrawlDetails" {
            let dest = segue.destination as! CrawlDetailViewController
            dest.crawl = crawlForPassing
            dest.transitioningDelegate = self
        } else if segue.identifier == "presentCreateForm" {
            let dest = segue.destination as! CreateCrawlViewController
            dest.transitioningDelegate = self
        }
    }
    
    lazy var crawlFetchedResultsController : NSFetchedResultsController<SavedCrawl> = {
        
        let fetchRequest:NSFetchRequest<SavedCrawl> = SavedCrawl.fetchRequest()
        
        let primarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        fetchRequest.fetchBatchSize = 20
        
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
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
        return crawlFetchedResultsController.fetchedObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let crawl = crawlFetchedResultsController.fetchedObjects![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "crawlCell", for: indexPath) as! CrawlTableViewCell
        
        
        cell.nameLabel.text = crawl.name!
        
        cell.cellView.layer.shadowPath = CGPath(roundedRect: cell.cellView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        cell.clipsToBounds = false
        cell.cellView.clipsToBounds = false
        cell.cellView.layer.shadowColor = shadowColorLight.cgColor
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cellView.layer.shadowRadius = 10
        cell.cellView.layer.shadowOpacity = 1
        
        
        var markers: [GMSMarker] = []
        
        var minLat: Double = 91
        var maxLat: Double = -91
        var minLong: Double = 181
        var maxLong: Double = -181
        
        let startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2D(latitude: crawl.startLat, longitude: crawl.startLong)
        
        if crawl.startLat < minLat {
            minLat = crawl.startLat
        }
        
        if crawl.startLat > maxLat {
            maxLat = crawl.startLat
        }
        
        if crawl.startLong < minLong {
            minLong = crawl.startLong
        }
        
        if crawl.startLong > maxLong {
            maxLong = crawl.startLong
        }
        
        startMarker.appearAnimation = .pop
        startMarker.icon = #imageLiteral(resourceName: "Pin")
        markers.append(startMarker)
        
        let endMarker = GMSMarker()
        endMarker.position = CLLocationCoordinate2D(latitude: crawl.endLat, longitude: crawl.endLong)
        
        if crawl.endLat < minLat {
            minLat = crawl.endLat
        }
        
        if crawl.endLat > maxLat {
            maxLat = crawl.endLat
        }
        
        if crawl.endLong < minLong {
            minLong = crawl.endLong
        }
        
        if crawl.endLong > maxLong {
            maxLong = crawl.endLong
        }
        
        endMarker.appearAnimation = .pop
        endMarker.icon = #imageLiteral(resourceName: "Pin")
        markers.append(endMarker)
        
        let path = GMSMutablePath()
        path.add(startMarker.position)
        
        for pub in crawl.pubs! {
            if let castedPub = pub as? Pub {
                
                let loc = CLLocationCoordinate2D(latitude: castedPub.lat, longitude: castedPub.long)
                
                if loc.latitude < minLat {
                    minLat = loc.latitude
                }
                
                if loc.latitude > maxLat {
                    maxLat = loc.latitude
                }
                
                if loc.longitude < minLong {
                    minLong = loc.longitude
                }
                
                if loc.longitude > maxLong {
                    maxLong = loc.longitude
                }
                
                
                let pubMarker = GMSMarker()
                pubMarker.position = loc
                pubMarker.appearAnimation = .pop
                pubMarker.icon = #imageLiteral(resourceName: "BeerPin")
                pubMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                markers.append(pubMarker)
                
                path.add(loc)
            }
        }
        
        path.add(endMarker.position)
        
        
        let midLat = (minLat + maxLat) / 2
        let midLong = (minLong + maxLong) / 2
        
        var zoomLevel: Double = 11
        let scale = distFrom(lat1: maxLat, lng1: maxLong, lat2: minLat, lng2: minLong) / 500
        zoomLevel = 16 - log(scale) / log(2)
        
        // A small buffer
        zoomLevel -= 0.8
        
        let camera = GMSCameraPosition.camera(withLatitude: midLat, longitude: midLong, zoom: Float(zoomLevel))
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: cell.mapHolder.frame.size.width, height: cell.mapHolder.frame.size.height), camera: camera)
        mapView.mapType = .normal
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2
        polyline.strokeColor = UIColor.colorWithHsb(323, s: 72, b: 44)
        polyline.map = mapView
        
        for marker in markers {
            marker.map = mapView
        }
        
        cell.mapHolder.isUserInteractionEnabled = false
        
        cell.mapHolder.addSubview(mapView)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 316
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        crawlForPassing = crawlFetchedResultsController.fetchedObjects![indexPath.row]
        self.performSegue(withIdentifier: "presentCrawlDetails", sender: nil)
    }
}

extension CrawlsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pageDismisser
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pageAnimator
    }
}
