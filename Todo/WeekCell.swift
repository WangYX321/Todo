//
//  WeekCell.swift
//  Todo
//
//  Created by wyx on 2017/8/29.
//  Copyright © 2017年 wyx. All rights reserved.
//

import UIKit

class WeekCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.backgroundColor = UIColor.lightGray
    }
}
