//
//  ConveyAccessToken.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation

class ConveyAccessToken: NSObject, NSCoding {
    let api: String?
    let chatkit: String?
    
    private let user_id: Int?
    private let chatkit_id: String?

    var user: User? {
        get {
            guard let user_id = self.user_id, let chatkit_id = self.chatkit_id else {
                return nil
            }

            return User(id: user_id, chatkit_id: chatkit_id)
        }
    }
    
    init(api: String?, chatkit: String?, user: User?) {
        self.api = api
        self.chatkit = chatkit
        self.user_id = user?.id
        self.chatkit_id = user?.chatkit_id
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let api = aDecoder.decodeObject(forKey: "api") as? String
        let chatkit = aDecoder.decodeObject(forKey: "chatkit") as? String
        let user_id = aDecoder.decodeObject(forKey: "user_id") as? Int
        let chatkit_id = aDecoder.decodeObject(forKey: "chatkit_id") as? String

        self.init(api: api, chatkit: chatkit, user: User(id: user_id, chatkit_id: chatkit_id))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(api, forKey: "api")
        aCoder.encode(chatkit, forKey: "chatkit")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(chatkit_id, forKey: "chatkit_id")
    }
    
}
