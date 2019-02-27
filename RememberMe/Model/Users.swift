//
//  Users.swift
//  RememberMe
//
//  Created by Clovis Magenta da Cunha on 29/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import Foundation
import RealmSwift

class Users : Object {
    
    @objc dynamic var userID : String = UUID().uuidString
    @objc dynamic var userName : String = ""
    @objc dynamic var firstName : String = ""
    @objc dynamic var familyName : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var country : String = ""
    @objc dynamic var city : String = ""
    @objc dynamic var password : String = ""
    @objc dynamic var dateCreation : Date = Date()
    @objc dynamic var validationCode : Int = 0
    
}
