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
    
    init(name: String, description: String, storeName: String, imageString: String) {
        self.name = name
        self.description = description
        self.storeName = storeName
        self.imageString = imageString
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let storeName = dictionary["storeName"] as! String? ?? ""
        let imageString = dictionary["image"] as! String? ?? ""
        self.init(name: name, description: description, storeName: storeName, imageString: imageString)
    }
}
