//
//  RestaurantLeanCollectionCell.swift
//  FoodPin
//
//  Created by angelorlover on 16/3/21.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import UIKit

protocol RestaurantLeanCollectionCellDelegate {
    func didLikeButtonPressed(cell: RestaurantLeanCollectionCell)
}

class RestaurantLeanCollectionCell: UICollectionViewCell {
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var likeButton : UIButton!
    
    var delegate: RestaurantLeanCollectionCellDelegate?
    
    @IBAction func like(sender: AnyObject) {
        delegate?.didLikeButtonPressed(self)
    }
    
    var isLike : Bool = false {
        didSet {
            if isLike {
                likeButton.setImage(UIImage(named: "heartfull"), forState: .Normal)
            } else {
                likeButton.setImage(UIImage(named: "heart"), forState: .Normal)
            }
        }
    }
    
}



