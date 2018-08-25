//
//  DeeplinkService.swift
//  Convey
//
//  Created by Neo Ighodaro on 25/08/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import Foundation

enum DeeplinkType {
    case room(room: [String: Any])
}

let Deeplinker = DeepLinkManager()

class DeepLinkManager {
    fileprivate init() {}
    
    private var deeplinkType: DeeplinkType?
    
    func checkDeepLink() {
        guard let deeplinkType = self.deeplinkType else {
            return
        }
        
        DeeplinkNavigator.shared.proceedToDeeplink(deeplinkType)
        
        self.deeplinkType = nil
    }
    
    func handleRemoteNotification(_ notification: [AnyHashable: Any]) {
        guard let data = notification["data"] as? [String: Any], let room = data["room"] as? [String: Any]
        else {
            return (self.deeplinkType = nil)
        }

        self.deeplinkType = DeeplinkType.room(room: room)
    }
}

class DeeplinkNavigator {
    static let shared = DeeplinkNavigator()
    
    private init() {}
    
    func proceedToDeeplink(_ type: DeeplinkType) {
        switch type {
        case .room(room: let room):
            print("Show room: \(room)")
//            if let rootVc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let vc = storyboard.instantiateViewController(withIdentifier: "StoryViewController") as? StoryViewController {
//                    vc.story = story
//                    rootVc.show(vc, sender: rootVc)
//                }
//            }
        }
    }
}
