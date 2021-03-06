//
//  PatientAppointmentChatController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class PatientAppointmentChatController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let api = API.shared
    let db = Firestore.firestore()
    
    var messages: [Message] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }
    
    var user: User
    var patient: Patient
    var messageGroup: MessageGroup
    var appointment: Appointment
    var appointmentInfo: AppointmentInformation
    var doctor: DoctorAPI?
    var doctorUser: User?
    var session: Session?
    
    init(user: User, patient: Patient, messageGroup: MessageGroup, appointment: Appointment, appointmentInfo: AppointmentInformation, doctor: DoctorAPI?, doctorUser: User?) {
        self.user = user
        self.patient = patient
        self.messageGroup = messageGroup
        self.appointment = appointment
        self.appointmentInfo = appointmentInfo
        self.doctor = doctor
        self.doctorUser = doctorUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTapAround()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        // loadMessages()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        db.collection("message-group").document("\(messageGroup.id)").collection("message").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                let docs = snapshot.documents
                self.messages = []
                for i in docs {
                    let message = Message(id: i["messageId"] as! Int, userId: i["userId"] as! Int, groupId: i["messageGroupId"] as! Int, content: i["content"] as! String, timestamp: i["timestamp"] as! String)
                    self.messages.append(message)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let du = self.doctorUser {
            self.navigationItem.title = "\(du.firstName) \(du.lastName)"
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    func loadMessages() {
        let docRef = db.collection("message-group").document("\(messageGroup.id)").collection("message")
        
        docRef.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                print("snapshot")
                let docs = snapshot.documents
                for i in docs {
                    let message = Message(id: i["messageId"] as! Int, userId: i["userId"] as! Int, groupId: i["messageGroupId"] as! Int, content: i["content"] as! String, timestamp: i["timestamp"] as! String)
                    self.messages.append(message)
                }
            }
        }
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> SenderType {
        return UserSender(senderId: "\(self.user.userId)", displayName: self.user.firstName + self.user.lastName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let u = self.messages[indexPath.row].userId == self.user.userId ? (self.user.firstName + " " + self.user.lastName) : "Patient"
        
        return ChatMessage(sender: UserSender(senderId: "\(self.messages[indexPath.row].userId)", displayName: u), messageId: "\(messages[indexPath.row].id)", sentDate: messages[indexPath.row].timestamp, kind: .text(messages[indexPath.row].content))
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let content = inputBar.inputTextView.text, content != "" {
            api.sendMessage(groupId: self.messageGroup.id, token: self.session!.token, content: content, success: { (response) in
                if let model = try? JSONDecoder().decode(Message.self, from: response) {
                    inputBar.inputTextView.text = ""
                }
            }) { (error) in
                print("Failure")
            }
        }
    }
}

struct UserSender: SenderType {
    var senderId: String
    var displayName: String
    
    init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
}

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: SenderType, messageId: String, sentDate: String, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = Date.convertDateStringToDate(date: sentDate) ?? Date()
        self.kind = kind
    }
}
