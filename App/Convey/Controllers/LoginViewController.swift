//
//  LoginViewController.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginButtonPressed(_ sender: Any?) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        UserService.shared.login(email: email, password: password) { token in
            guard token != nil else {
                return StatusBarNotificationBanner(title: "Invalid email or password", style: .danger).show()
            }
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }

}
