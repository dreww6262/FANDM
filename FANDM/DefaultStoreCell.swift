//
//  DefaultStoreCell.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/15/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class DefaultStoreCell: UICollectionViewCell {
    let name = UILabel()
    let image = UIImageView()
    let favButton = UIButton()
    var store: Store?
    
    override func layoutSubviews() {
        contentView.addSubview(name)
        contentView.addSubview(image)
        contentView.addSubview(favButton)
    }
    
}
