//
//  WelcomeViewController.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if AuthService.shared.isLoggedIn() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func welcomeButtonPressed(_ sender: Any?) {
        performSegue(withIdentifier: "Signup", sender: self)
    }

}
