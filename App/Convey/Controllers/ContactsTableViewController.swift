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
    
    var rooms: [[String: Any]] = []
    var friendTextField: UITextField?
    var selectedRoom: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ChatkitService.shared.rooms { [unowned self] (rooms, error) in
            guard let rooms = rooms, error == nil else {
                return StatusBarNotificationBanner(title: "Unable to load rooms", style: .danger).show()
            }
            
            DispatchQueue.main.async {
                self.rooms = rooms
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutButtonWasPressed(_ sender: Any) {
        AuthService.shared.logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFriendButtonWasPressed(_ sender: Any) {
        let alertCtl = UIAlertController(title: "Add friend", message: "Enter friends email address", preferredStyle: .alert)
        
        alertCtl.addTextField { [unowned self] textfield in
            self.friendTextField = textfield
            textfield.placeholder = "Enter email address"
        }
        
        alertCtl.addAction(UIAlertAction(title: "Add", style: .default) { action in
            if let email = self.friendTextField?.text {
                UserService.shared.addUser(email: email) { [unowned self] data in
                    guard let room = data else {
                        return StatusBarNotificationBanner(title: "Unable to add user.", style: .danger).show()
                    }
                    
                    self.rooms.append(room)
                    self.tableView.reloadData()
                    StatusBarNotificationBanner(title: "Friend has been added.").show()
                }
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)
        let room = self.rooms[indexPath.row]
        
        let roomName = room["name"] as! String
        let prefix = (room["channel"] as! Bool) ? "# " : ""

        cell.textLabel?.text = "\(prefix)\(roomName)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoom = rooms[indexPath.row]
        
        performSegue(withIdentifier: "chatroom", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ChatroomViewController {
            dest.room = selectedRoom
        }
    }

}
