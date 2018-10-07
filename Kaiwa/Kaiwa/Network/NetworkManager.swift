//
//  NetworkManager.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol NetworkManager {
    var firebaseDBConnection: DatabaseReference { get set }
    
    func fetchFirebaseDB<T: Decodable> (endpoint: Endpoint, completion: @escaping (_ data: T?, _ error: Error?) -> Void)
}

extension NetworkManager where Self: Global.Network {
    func fetchFirebaseDB<T: Decodable> (endpoint: Endpoint, completion: @escaping (_ data: T?, _ error: Error?) -> Void) {
        guard let path = endpoint.path else { return }
        let realtimeDBRef = self.firebaseDBConnection.child(path)
        
        if let body = endpoint.body {
            //update
            if endpoint.requestType == .storeSingleObject {
                realtimeDBRef.setValue(body)
                
                if let data = body as? T {
                    completion(data, nil)
                }else{
                    completion(nil, nil)
                }
            }
        }else{
            //query
            if endpoint.requestType == .querySingleObject {
                ///realtimeDBRef.observeSin
            }
        }
    }
}

extension NetworkManager where Self: Global.DemoNetwok {
    func fetchFirebaseDB<T: Decodable> (endpoint: Endpoint, completion: @escaping (_ data: T?, _ error: Error?) -> Void) {
    }
}

