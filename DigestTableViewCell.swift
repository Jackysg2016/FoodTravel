//
//  DigestTableViewCell.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/26.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit

class DigestTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
