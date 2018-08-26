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
import PushNotifications

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
    
    func rooms(handler: @escaping([[String: Any]]?, ChatkitError?) -> Void) {
        request("/api/rooms", .get, params: nil, headers: authHeader()) { resp in
            guard let data = resp as? [[String: Any]] else { return handler(nil, .unableToConnect) }
            handler(data, nil)
        }
    }

    func joinableRooms(completion: @escaping([[String: AnyObject]]?, ChatkitError?) -> Void) {
        request("/api/rooms/joinable", .get, params: nil, headers: authHeader()) { resp in
            guard let data = resp as? [[String: AnyObject]] else { return completion(nil, .unableToConnect) }
            completion(data, nil)
        }
    }
    
    func addUserToRoom(room: PCRoom, handler: @escaping(Bool) -> Void) {
        let params: [String: Any] = [
            "name": room.name,
            "room_id": room.id,
        ]
        
        request("/api/rooms/add", .post, params: params, headers: authHeader()) { resp in
            guard let _ = resp else { return handler(false) }
            try? PushNotifications.shared.subscribe(interest: "\(room.id)")
            handler(true)
        }
    }
    
    func notifySentMessage(room: PCRoom, message: String) {
        let headers = authHeader()
        let params: [String: Any] = ["chatkit_room_id": room.id, "message": message]
        request("/api/rooms/sent_message", .post, params: params, headers: headers)
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
