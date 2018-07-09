//
//  AuthService.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation

class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    func isLoggedIn() -> Bool {
        return getAccessToken() != nil
    }
    
    func logout() {
        ConveyAccessTokenService.shared.deleteToken()
    }
    
    func getAccessToken() -> ConveyAccessToken? {
        guard let token = ConveyAccessTokenService.shared.fetch() else { return nil }
        guard token.chatkit != nil, token.api != nil else { return nil }

        return token
    }
    
    func setToken(_ token: ConveyAccessToken) {
        ConveyAccessTokenService.shared.save(token: token)
    }
    
}
