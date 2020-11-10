//
//  PunchCard.swift
//  FANDM
//
//  Created by Andrew Williamson on 10/19/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import Foundation
import Firebase

class PunchCard {
    
    var username: String
    var index: Int
    var dateCreated: Date
    var dateRedeemed: Date?
    var docID: String
    
    var dictionary: [String: Any] {
        return ["username": username, "index": index, "dateCreated": dateCreated, "dateRedeemed": dateRedeemed ?? "", "docID": docID]
    }
    
    init (username: String, index: Int, dateCreated: Date, dateRedeemed: Date?, docID: String) {
        self.username = username
        self.index = index
        self.dateCreated = dateCreated
        self.dateRedeemed = dateRedeemed
        self.docID = docID
    }
    
    convenience init(dictionary: [String: Any]) {
        let username = dictionary["username"] as! String? ?? ""
        let index = dictionary["index"] as! Int? ?? 0
        let dateCreated = (dictionary["dateCreated"] as! Timestamp? ?? Timestamp()).dateValue()
        let redeemedTimestamp = dictionary["dateRedeemed"]
        var dateRedeemed: Date?
        if redeemedTimestamp is Timestamp {
            dateRedeemed = (redeemedTimestamp as! Timestamp).dateValue()
        }
        let docID = dictionary["docID"] as! String? ?? ""
        
        
        self.init(username: username, index: index, dateCreated: dateCreated, dateRedeemed: dateRedeemed, docID: docID)
    }
    
}
