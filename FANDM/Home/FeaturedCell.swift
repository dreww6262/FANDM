//
//  FeaturedCell.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/27/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class FeaturedCell: UICollectionViewCell {
    var homeItem: HomeItem?
    
    let button = UIButton()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let promoImage = UIImageView()
    
    override func layoutSubviews() {
        contentView.addSubview(button)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(promoImage)
    }
}
