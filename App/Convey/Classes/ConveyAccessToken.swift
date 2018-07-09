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
    
    init(api: String?, chatkit: String?) {
        self.api = api
        self.chatkit = chatkit
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let api = aDecoder.decodeObject(forKey: "api") as? String
        let chatkit = aDecoder.decodeObject(forKey: "chatkit") as? String

        self.init(api: api, chatkit: chatkit)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(api, forKey: "api")
        aCoder.encode(chatkit, forKey: "chatkit")
    }
    
}
