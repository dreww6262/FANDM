//
//  Store.swift
//  FANDM
//
//  Created by Andrew Williamson on 10/12/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import Foundation

class Store {
    var name: String
    var description: String
    var imageLink: String
    var type: String
    
    
    var dictionary: [String: Any] {
        return ["name": name, "description": description, "image": imageLink, "type": type]
    }
    
    init(name: String, description: String, imageLink: String, type: String) {
        self.name = name
        self.description = description
        self.imageLink = imageLink
        self.type = type
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let imageLink = dictionary["image"] as! String? ?? ""
        let type = dictionary["type"] as! String? ?? ""
        
        self.init(name: name, description: description, imageLink: imageLink, type: type)
    }
}
