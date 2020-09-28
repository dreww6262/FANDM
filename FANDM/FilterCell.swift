//
//  FilterCell.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/15/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var filterButton: UIButton!
    var buttonName: String = "" {
        didSet {
            filterButton.setTitle(buttonName, for: .normal)
            filterButton.isUserInteractionEnabled = true
            switch buttonName {
            //case "Restaurants":
                // color is correct
            case "Shops":
                filterButton.setTitleColor(UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.0), for: .normal)
            case "Services":
                filterButton.setTitleColor(UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.0), for: .normal)
            case "Entertainment":
                filterButton.setTitleColor(UIColor(red: 0.93, green: 0.75, blue: 0.27, alpha: 1.0), for: .normal)
            default:
                print("Restaurant or Bad Button Name: \(buttonName)")
            }
        }
    }
    var buttonIcon: UIImage?
    
}
