//
//  Network.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol KaiwaNetwork: Usernetwork, NetworkManager { }

struct Global{
    class Network: KaiwaNetwork {
        var user: UserData?
        
        var firebaseDBConnection: DatabaseReference
        
        init(){
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://kaiwa-1fe22.firebaseio.com/")
        }
        // real data
    }
    
    class DemoNetwok: KaiwaNetwork {
        var user: UserData?
        
        var firebaseDBConnection: DatabaseReference
        
        
        init(){
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://kaiwa-1fe22.firebaseio.com/")
        }
        
        // fake json data
    }
}

