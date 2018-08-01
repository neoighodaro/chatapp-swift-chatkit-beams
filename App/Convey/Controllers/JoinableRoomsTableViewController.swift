//
//  JoinableRoomsTableViewController.swift
//  Convey
//
//  Created by Neo Ighodaro on 31/07/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import PusherPlatform
import PusherChatkit
import NotificationBannerSwift

class JoinableRoomsTableViewController: UITableViewController, PCChatManagerDelegate {
    
    var rooms: [PCRoom] = []

    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatkitService.shared.joinableRooms { rooms, error in
            guard error == nil, let roomsPayload = rooms else {
                return StatusBarNotificationBanner(title: "Unable to fetch rooms", style: .danger).show()
            }
            
            let rooms = try? roomsPayload.compactMap { room -> PCRoom? in
                guard
                    let roomId = room["id"] as? Int,
                    let roomName = room["name"] as? String,
                    let isPrivate = room["private"] as? Bool,
                    let roomCreatorUserId = room["created_by_id"] as? String,
                    let roomCreatedAt = room["created_at"] as? String,
                    let roomUpdatedAt = room["updated_at"] as? String
                    else {
                        throw PCPayloadDeserializerError.incompleteOrInvalidPayloadToCreteEntity(
                            type: String(describing: PCRoom.self),
                            payload: room
                        )
                }
                
                var memberUserIdsSet: Set<String>?
                
                if let memberUserIds = room["member_user_ids"] as? [String] {
                    memberUserIdsSet = Set<String>(memberUserIds)
                }
                
                return PCRoom(
                    id: roomId,
                    name: roomName,
                    isPrivate: isPrivate,
                    createdByUserId: roomCreatorUserId,
                    createdAt: roomCreatedAt,
                    updatedAt: roomUpdatedAt,
                    deletedAt: room["deleted_at"] as? String,
                    userIds: memberUserIdsSet
                )
            }
            
            if let rooms = rooms {
                self.rooms = rooms
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "room", for: indexPath)
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
