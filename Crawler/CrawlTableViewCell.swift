//
//  CrawlTableViewCell.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit

class CrawlTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var mapHolder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
