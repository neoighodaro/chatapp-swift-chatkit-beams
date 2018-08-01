//
//  ChatkitService.swift
//  Convey
//
//  Created by Neo Ighodaro on 31/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation
import PusherChatkit
import PusherPlatform

enum ChatkitError: Error {
    case unableToConnect
}


class ChatkitService: ServiceRequest {
    static let shared = ChatkitService()
    
    var currentUser: PCCurrentUser? = nil

    let chatManager: ChatManager?
    
    override private init() {
        if let user = UserService.shared.user, let chatkit_id = user.chatkit_id {
            self.chatManager = ChatManager(
                instanceLocator: AppConstants.INSTANCE_LOCATOR,
                tokenProvider: CKServiceTokenProvider(),
                userId: chatkit_id
            )
        } else {
            self.chatManager = nil
        }
    }

    func joinableRooms(completion: @escaping([[String: AnyObject]]?, ChatkitError?) -> Void) {
        request("/api/rooms", .get, params: nil, headers: authHeader()) { resp in
            guard let data = resp as? [[String: AnyObject]] else { return completion(nil, .unableToConnect) }
            completion(data, nil)
        }
    }
}


class CKServiceTokenProvider: PPTokenProvider {
    func fetchToken(completionHandler: @escaping (PPTokenProviderResult) -> Void) {
        if let token = AuthService.shared.getAccessToken(), let ckToken = token.chatkit {
            return completionHandler(.success(token: ckToken))
        }
        
        completionHandler(.error(error: PCError.currentUserIsNil))
    }
}
