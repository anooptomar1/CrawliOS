//
//  CrawlDetailViewController.swift
//  Crawler
//
//  Created by Jack Chorley on 12/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit

class CrawlDetailViewController: UIViewController {

    var crawl: SavedCrawl!
    
    var sortedPubs: [Pub]!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var crawlTitleLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crawlTitleLabel.text = crawl.name!.capitalized
        
        headerView.layer.shadowPath = CGPath(roundedRect: headerView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        headerView.clipsToBounds = false
        headerView.layer.shadowColor = shadowColor.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowRadius = 10
        headerView.layer.shadowOpacity = 1
        
        sortedPubs = (crawl.pubs!.allObjects as! [Pub]).sorted { (p1, p2) -> Bool in
            p1.id < p2.id
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentARScene", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CrawlDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPubs.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == crawl.pubs!.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "spacerCell", for: indexPath)
            return cell
        }
        
        let pub = sortedPubs[indexPath.row - 1] as! Pub
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pubCell", for: indexPath) as! CrawlDetailTableViewCell
        
        cell.cellView.layer.shadowPath = CGPath(roundedRect: cell.cellView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        cell.clipsToBounds = false
        cell.cellView.clipsToBounds = false
        cell.cellView.layer.shadowColor = shadowColorLight.cgColor
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cellView.layer.shadowRadius = 10
        cell.cellView.layer.shadowOpacity = 1
        
        cell.activitySpinner.hidesWhenStopped = true
        cell.activitySpinner.startAnimating()
        
        cell.nameLabel.text = pub.name!
        
        if pub.rating < 0 {
            for star in cell.starImages {
                star.isHidden = true
            }
        } else {
            for star in cell.starImages {
                star.image = #imageLiteral(resourceName: "StarUnfilled")
                star.isHidden = false
            }
        }
        
        if pub.rating >= 0.5 {
            cell.starImages[0].image = #imageLiteral(resourceName: "StarFilled")
        }
        
        if pub.rating >= 1.5 {
            cell.starImages[1].image = #imageLiteral(resourceName: "StarFilled")
        }
        
        if pub.rating >= 2.5 {
            cell.starImages[2].image = #imageLiteral(resourceName: "StarFilled")
        }
        
        if pub.rating >= 3.5 {
            cell.starImages[3].image = #imageLiteral(resourceName: "StarFilled")
        }
        
        if pub.rating >= 4.5 {
            cell.starImages[4].image = #imageLiteral(resourceName: "StarFilled")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == crawl.pubs!.count + 1 {
            return 42
        }
        
        return 100
    }
}
