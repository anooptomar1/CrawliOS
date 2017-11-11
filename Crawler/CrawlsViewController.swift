//
//  ViewController.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit
import CoreData

class CrawlsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let shadowColor = UIColor.colorWithHsb(0, s: 0, b: 39, a: 0.12)
    
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

