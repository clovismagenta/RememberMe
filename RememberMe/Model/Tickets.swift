//
//  Tickets.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import Foundation
import RealmSwift

class Tickets : Object {
    
    @objc dynamic var ticketID : String = UUID().uuidString
    @objc dynamic var ticketDescription: String = ""
    @objc dynamic var ticketDone : Bool = false
    
    var myItems = List<Item>()
    
}
