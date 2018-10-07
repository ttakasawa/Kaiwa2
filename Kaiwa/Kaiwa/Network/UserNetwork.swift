//
//  UserNetwork.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase

protocol Usernetwork {
    var user: UserData? { get set }
    
    func createUser(user: UserData, completion: @escaping( _ success: Bool) -> Void)
    func login(user: UserData, completion: @escaping( _ success: Bool) -> Void)
}

extension Usernetwork where Self: NetworkManager {
    func createUser(user: UserData, completion: @escaping( _ success: Bool) -> Void){
        
    }
    func login(user: UserData, completion: @escaping( _ success: Bool) -> Void){
        
    }
}
