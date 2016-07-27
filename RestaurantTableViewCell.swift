//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by Yapzi on 16/5/11.
//  Copyright © 2016年 Yap. All rights reserved.
//

import UIKit


class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet var NameLable: UILabel!
    @IBOutlet var LocationLable: UILabel!
    @IBOutlet var TypeLable: UILabel!
    @IBOutlet var ThumbImageView: UIImageView!
    @IBOutlet var visitedMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
