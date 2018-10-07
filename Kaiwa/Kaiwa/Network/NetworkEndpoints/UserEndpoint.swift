//
//  UserEndpoint.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum UserEndpoint: Endpoint {
    
    case login(email: String, password: String)
    case getUser(id: String)
    case updateUser(user: UserData)
    
    var path: String? {
        switch self {
        case .login( _, _):
            return nil
        case .getUser(let id):
            return id
        case .updateUser(let user):
            return user.uid
        }
    }
    
    var body: Any? {
        switch self {
        case .login( _, _), .getUser( _):
            return nil
        case .updateUser(let user):
            return self.toData(data: user)
        }
    }
    
    var requestType: EndpointTypes {
        switch self {
        case .login( _, _):
            return .auth
        case .getUser( _):
            return .querySingleObject
        case .updateUser( _):
            return .storeSingleObject
        }
    }
}
