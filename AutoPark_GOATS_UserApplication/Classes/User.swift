//
//  User.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit

class User: NSObject {
    var id:Int
    var firstName:String
    var lastName:String
    var email: String
    var phoneNumber: Int32
    
    init(id : Int, firstName: String, lastName: String, email: String, phoneNumber: Int32) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
