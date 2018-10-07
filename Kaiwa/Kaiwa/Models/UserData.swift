//
//  UserData.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class UserData: Codable {
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var language: Languages? = .en
    
    init(uid: String, firstName: String, lastName: String, email: String, password: String){
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}



