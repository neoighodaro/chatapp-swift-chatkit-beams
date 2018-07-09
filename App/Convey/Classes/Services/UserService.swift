//
//  UserService.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation
import Alamofire

class UserService {

    static let shared = UserService()
    
    private init() {}
    
    func login(email: String, password: String, handler: @escaping(ConveyAccessToken?) -> Void) {
        let params = [
            "username": email,
            "password": password,
            "grant_type": "password",
            "client_id": AppConstants.CLIENT_ID,
            "client_secret": AppConstants.CLIENT_SECRET,
        ]
        
        request("/oauth/token", .post, params: params, headers: nil) { resp in
            guard let data = resp as? [String: Any] else { return handler(nil) }
            guard let apiToken = data["access_token"] as? String else { return handler(nil) }
            
            let headers = self.authHeader(token: apiToken)
            
            self.request("/api/chatkit/token", .post, params: nil, headers: headers) { resp in
                guard let data = resp as? [String: Any] else { return handler(nil) }
                guard let ckToken = data["access_token"] as? String else { return handler(nil) }

                let token = ConveyAccessToken(api: apiToken, chatkit: ckToken)
                
                AuthService.shared.setToken(token)
                handler(token)
            }
        }
    }

    func createAccount(name: String, email: String, password: String, handler: @escaping([String: Any]?) -> Void) {
        let params = ["name": name, "email": email, "password": password]
        
        request("/api/users/signup", .post, params: params, headers: nil) { resp in
            guard let data = resp as? [String: Any] else { return handler(nil) }
            
            self.login(email: email, password: password) { resp in
                guard resp != nil else { return handler(nil) }
                handler(data)
            }
        }
    }
    
    fileprivate func request(_ url: String, _ method: HTTPMethod = .get, params: Parameters?, headers: HTTPHeaders?, handler: @escaping(AnyObject?) -> Void) {
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
    
    fileprivate func authHeader(token: String?) -> HTTPHeaders {
        let accessToken = (token == nil) ? AuthService.shared.getAccessToken()?.chatkit : token
        return [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken!)"
        ]
    }
}
