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
    var lat: Double
    var long: Double
    var address: String
    var phone: String
    var website: String
    
    var dictionary: [String: Any] {
        return ["name": name, "description": description, "image": imageLink, "type": type, "lat": lat, "long": long, "address": address, "phone": phone, "website": website]
    }
    
    init(name: String, description: String, imageLink: String, type: String, lat: Double, long: Double, address: String, phone: String, website: String) {
        self.name = name
        self.description = description
        self.imageLink = imageLink
        self.type = type
        self.lat = lat
        self.long = long
        self.phone = phone
        self.address = address
        self.website = website
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let imageLink = dictionary["image"] as! String? ?? ""
        let type = dictionary["type"] as! String? ?? ""
        let lat = dictionary["lat"] as! Double? ?? 0.0
        let long = dictionary["long"] as! Double? ?? 0.0
        let phone = dictionary["phone"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let website = dictionary["website"] as! String? ?? ""
        
        self.init(name: name, description: description, imageLink: imageLink, type: type, lat: lat, long: long, address: address, phone: phone, website: website)
    }
}
