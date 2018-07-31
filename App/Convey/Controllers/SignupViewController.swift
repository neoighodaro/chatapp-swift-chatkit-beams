//
//  SignupViewController.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupButtonPressed(_ sender: Any?) {
        guard let name = fullNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        UserService.shared.signup(name: name, email: email, password: password) { user in
            if user == nil {
                return StatusBarNotificationBanner(title: "Cant create account", style: .danger).show()
            }
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
}
