//
//  APIClient.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Alamofire

class APIClient: NSObject {
    static let shared = APIClient()
    var baseURLString: String = "https://us-central1-kaiwa-1fe22.cloudfunctions.net/app"
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    func test(){
        let url = self.baseURL.appendingPathComponent("abc")
        Alamofire.request(url, method: .post, parameters: [
            "abc": "def"
        ]).validate(statusCode: 200..<300).responseString { (response) in
                
            switch response.result {
            case .success:
                print("success")
            case .failure:
                print("fail")
            }
        }
    }
}
