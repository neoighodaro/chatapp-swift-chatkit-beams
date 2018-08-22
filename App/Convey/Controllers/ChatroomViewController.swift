//
//  ChatroomViewController.swift
//  Convey
//
//  Created by Neo Ighodaro on 22/08/2018.
//  Copyright © 2018 TapSharp. All rights reserved.
//

import UIKit
import MessageKit
import PusherChatkit
import NotificationBannerSwift

class ChatroomViewController: MessagesViewController, PCChatManagerDelegate {
    var messages: [Message] = []
    var room: [String: Any] = [:]
    var currentRoom: PCRoom? = nil
    var currentUser: PCCurrentUser? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMessageKit()
        
        navigationItem.title = room["name"] as? String
        
        ChatkitService.shared.chatManager?.connect(delegate: self) { [unowned self] (currentUser, error) in
            guard error == nil,
                let user = currentUser,
                let roomId = self.room["chatkit_room_id"] as? Int,
                let room = user.rooms.first(where: { $0.id == roomId })
            else {
                return StatusBarNotificationBanner(title: "Unable to load room", style: .danger).show()
            }
            
            self.currentRoom = room
            self.currentUser = currentUser
            currentUser?.subscribeToRoom(room: room, roomDelegate: self)
        }
    }

    func configureMessageKit() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // Input bar
        messageInputBar = MessageInputBar()
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        messageInputBar.delegate = self
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.isTranslucent = false
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 192/255, green: 204/255, blue: 218/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 0
        reloadInputViews()
        
        // Keyboard and send btn
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
}


extension ChatroomViewController: MessagesDataSource {
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender == currentSender()
    }
    
    func currentSender() -> Sender {
        return Sender(id: currentUser!.id, displayName: (currentUser!.name)!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.initials = initials(fromName: message.sender.displayName)
    }
    
    func initials(fromName name: String?) -> String {
        var initials = ""
        
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let secondWord = initialsArray.last {
                if let secondLetter = secondWord.first {
                    initials += String(secondLetter).capitalized
                }
            }
        } else {
            initials = "?"
        }
        
        return initials
    }
}


extension ChatroomViewController: MessagesLayoutDelegate {
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageBottom)
    }
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        return isFromCurrentSender(message: message)
            ? UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
            : UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }
}


extension ChatroomViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message)
            ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}


extension ChatroomViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        currentUser?.sendMessage(roomId: currentRoom!.id, text: text) { msgId, error in
            if error == nil {
                DispatchQueue.main.async { inputBar.inputTextView.text = String() }
            }
        }
    }
}


extension ChatroomViewController: PCRoomDelegate {
    func newMessage(message: PCMessage) {
        let msg = Message(
            text: message.text!,
            sender: Sender(id: message.sender.id, displayName: message.sender.displayName),
            messageId: String(describing: message.id),
            date: ISO8601DateFormatter().date(from: message.createdAt)!
        )
        
        DispatchQueue.main.async {
            self.messages.append(msg)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
    }
}
