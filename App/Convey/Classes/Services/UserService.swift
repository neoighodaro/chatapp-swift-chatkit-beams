//
//  UserService.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation
import Alamofire

struct User {
    let id: Int?
    let chatkit_id: String?
}

class UserService: ServiceRequest {

    static let shared = UserService()

    var user: User? {
        get {
            return AuthService.shared.getAccessToken()?.user
        }
    }
    
    private override init() {}
    
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
                guard let data = resp as? [String: Any], let user = data["user"] as? [String: Any] else { return handler(nil) }
                guard let ckToken = data["access_token"] as? String else { return handler(nil) }
                guard let chatkit_id = user["chatkit_id"] as? String else { return handler(nil) }
                guard let id = user["id"] as? Int else { return handler(nil) }
                
                let theUser = User(id: id, chatkit_id: chatkit_id)
                let token = ConveyAccessToken(api: apiToken, chatkit: ckToken, user: theUser)
                
                AuthService.shared.setToken(token)
                handler(token)
            }
        }
    }

    func signup(name: String, email: String, password: String, handler: @escaping([String: Any]?) -> Void) {
        let params = ["name": name, "email": email, "password": password]
        
        request("/api/users/signup", .post, params: params, headers: nil) { resp in
            guard let data = resp as? [String: Any] else { return handler(nil) }
            
            self.login(email: email, password: password) { resp in
                guard resp != nil else { return handler(nil) }
                handler(data)
            }
        }
    }
    
}
