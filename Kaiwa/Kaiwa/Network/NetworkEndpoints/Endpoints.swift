//
//  Endpoints.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import CodableFirebase

enum EndpointTypes{
    case auth
    
    case querySingleObject
    case storeSingleObject
}

protocol Endpoint {
    var path: String? { get }
    var body: Any? { get }
    var requestType: EndpointTypes { get }
    
    func toData<T: Encodable>(data: T) -> Any?
}

extension Endpoint {
    func toData<T: Encodable>(data: T) -> Any? {
        let encoder = FirebaseEncoder()
        do{
            let jsonData = try encoder.encode(data)
            return jsonData
        }catch{
            return nil
        }
    }
}
