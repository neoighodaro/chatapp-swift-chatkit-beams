//
//  ConveyAccessTokenService.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation
import PusherPlatform

class ConveyAccessTokenService: PPTokenProvider {

    static let key = "CONVEY_TOKEN"
    
    static let shared = ConveyAccessTokenService()
    
    private init() {}
    
    func fetch() -> ConveyAccessToken? {
        guard let token = UserDefaults.standard.object(forKey: ConveyAccessTokenService.key) as? Data else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: token) as? ConveyAccessToken
    }
    
    func save(token: ConveyAccessToken) {
        let data = NSKeyedArchiver.archivedData(withRootObject: token)
        UserDefaults.standard.set(data, forKey: ConveyAccessTokenService.key)
    }

    func fetchToken(completionHandler: @escaping (PPTokenProviderResult) -> Void) {
        guard let token = fetch(), let chatkitToken = token.chatkit else {
            let err = ConveyAccessTokenServiceError.validAccessTokenNotPresentInDatastore
            return completionHandler(.error(error: err))
        }
        
        completionHandler(.success(token: chatkitToken))
    }

}

enum ConveyAccessTokenServiceError: Error {
    case validAccessTokenNotPresentInDatastore
}
