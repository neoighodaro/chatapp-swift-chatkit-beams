//
//  ViewController.swift
//  convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        performSegue(withIdentifier: "Welcome", sender: self)
    }
    
}

