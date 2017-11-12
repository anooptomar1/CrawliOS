//
//  CrawlDetailTableViewCell.swift
//  Crawler
//
//  Created by Jack Chorley on 12/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit

class CrawlDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
