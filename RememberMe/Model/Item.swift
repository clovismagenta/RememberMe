//
//  Item.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var itemID : String = UUID().uuidString
    @objc dynamic var itemDescription : String = ""
    @objc dynamic var itemDone : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    @objc dynamic var maturityDate : Date?
    @objc dynamic var details : String?
    
    var parentTicket = LinkingObjects(fromType: Tickets.self, property: "myItems")
    
}
