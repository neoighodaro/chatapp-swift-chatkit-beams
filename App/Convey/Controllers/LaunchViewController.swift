//
//  ViewController.swift
//  convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyboardID = AuthService.shared.isLoggedIn() ? "Contacts" : "Welcome"
        performSegue(withIdentifier: storyboardID, sender: self)
    }
    
}

