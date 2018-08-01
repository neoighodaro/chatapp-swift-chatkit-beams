//
//  ContactsTableViewController.swift
//  Convey
//
//  Created by Neo Ighodaro on 09/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import PusherChatkit
import NotificationBannerSwift

class ContactsTableViewController: UITableViewController, PCChatManagerDelegate {
    
    var rooms: [PCRoom] = []
    var friendTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ChatkitService.shared.chatManager?.connect(delegate: self) { user, error in
//            guard let user = user, error == nil else {
//                return StatusBarNotificationBanner(title: "Unable to fetch rooms", style: .danger).show()
//            }
//            
//            self.rooms = user.rooms
//            self.tableView.reloadData()
//        }
    }
    
    @IBAction func addFriendButtonWasPressed(_ sender: Any) {
        let alertCtl = UIAlertController(title: "Add friend", message: "Enter friends email address", preferredStyle: .alert)
        
        alertCtl.addTextField { [unowned self] textfield in
            self.friendTextField = textfield
            textfield.placeholder = "Enter email address"
        }
        
        alertCtl.addAction(UIAlertAction(title: "Add", style: .default) { action in
            if let user = self.friendTextField?.text {
                print(user)
            }
        })
        
        alertCtl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertCtl, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
