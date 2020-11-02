//
//  HomeItem.swift
//  FANDM
//
//  Created by Andrew Williamson on 10/19/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import Foundation

class HomeItem {
    var name: String
    var description: String
    var storeName: String
    var imageString: String
    var moreInfoLink: String
    
    init(name: String, description: String, storeName: String, imageString: String, moreInfoLink: String) {
        self.name = name
        self.description = description
        self.storeName = storeName
        self.imageString = imageString
        self.moreInfoLink = moreInfoLink
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let storeName = dictionary["storeName"] as! String? ?? ""
        let imageString = dictionary["image"] as! String? ?? ""
        let moreInfoLink = dictionary["moreInfoLink"] as! String? ?? ""
        self.init(name: name, description: description, storeName: storeName, imageString: imageString, moreInfoLink: moreInfoLink)
    }
}
