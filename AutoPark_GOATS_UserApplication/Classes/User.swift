//
//  User.swift
//  AutoPark_GOATS_UserApplication
//
//  Created by cuilin on 2020-10-05.
//

import UIKit

class User: NSObject {
    var userId:String
    var password:String
    var firstName:String
    var lastName:String
    var email: String
    var phoneNumber: String
    
    init(userId : String,password:String, firstName: String, lastName: String, email: String, phoneNumber: String) {
        self.userId = userId
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
