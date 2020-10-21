//
//  UserData.swift
//  FANDM
//
//  Created by Andrew Williamson on 10/19/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import Foundation

class UserData {
    var firstName: String
    var lastName: String
    var username: String
    var email: String
    var favoriteStores: [String]
    
    var dictionary: [String: Any] {
        return ["firstName": firstName, "lastName": lastName, "username": username, "email": email, "favoriteStores": favoriteStores]
    }
    
    init(firstName: String, lastName: String, username: String, email: String, favoriteStores: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.favoriteStores = favoriteStores
    }
    
    convenience init(dictionary: [String: Any]) {
        let firstName = dictionary["firstName"] as! String? ?? ""
        let lastName = dictionary["lastName"] as! String? ?? ""
        let username = dictionary["username"] as! String? ?? ""
        let email = dictionary["email"] as! String? ?? ""
        let favoriteStores = dictionary["favoriteStores"] as! [String]? ?? [String]()
        
        self.init(firstName: firstName, lastName: lastName, username: username, email: email, favoriteStores: favoriteStores)
    }
    
}
