//
//  BusinessCell.swift
//  Yelp
//
//  Created by Jennifer Lee on 2/10/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var ratingsImageView: UIImageView!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            categoryLabel.text = business.categories
            ratingsLabel.text = "\(business.reviewCount!)"

            ratingsImageView.setImageWithURL(business.ratingImageURL!)
            thumbnailImageView.setImageWithURL(business.imageURL!)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
