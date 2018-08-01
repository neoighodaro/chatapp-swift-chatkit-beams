//
//  ServiceRequest.swift
//  Convey
//
//  Created by Neo Ighodaro on 31/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation
import Alamofire

class ServiceRequest {
    
    func request(_ url: String, _ method: HTTPMethod = .get, params: Parameters?, headers: HTTPHeaders?, handler: @escaping(AnyObject?) -> Void) {
        let encoding = JSONEncoding.default
        let url = AppConstants.ENDPOINT + url
        
        Alamofire
            .request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { resp in
                guard resp.result.isSuccess else { return handler(nil) }
                handler(resp.result.value as AnyObject)
        }
    }
    
    func authHeader(token: String? = nil) -> HTTPHeaders {
        let accessToken = (token == nil) ? AuthService.shared.getAccessToken()?.api : token
        return [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken!)"
        ]
    }
    
}
