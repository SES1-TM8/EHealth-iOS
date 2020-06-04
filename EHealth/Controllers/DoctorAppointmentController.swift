//
//  DoctorAppointmentController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorAppointmentController: UIViewController {
    
    let api = API.shared
    
    var user: User
    var doctor: DoctorAPI
    var appointment: Appointment
    var appointmentInfo: AppointmentInformation
    var group: MessageGroup?
    
    var patient: Patient?
    var patientUser: User?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.textColor = UIColor.black
        label.text = "Appointment"
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-Regular", size: 19)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    var descriptionField: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = Theme.background
        textView.text = "Injury Description"
        textView.textColor = UIColor.black
        textView.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        textView.isEditable = false
        
        return textView
    }()
    
    var attachedImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.imageFromServerURL(urlString: "https://ehealthcare-uts.s3-ap-southeast-2.amazonaws.com/15912484261172769499e-c463-4ece-86ec-b435a2cd3b66.jpeg")
        
        return imageView
    }()
    
    var chatButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        
        return button
    }()
    
    init(user: User, doctor: DoctorAPI, appointment: Appointment, info: AppointmentInformation) {
        self.user = user
        self.doctor = doctor
        self.appointment = appointment
        self.appointmentInfo = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        var patientName = "a patient"
        
        api.getPatientForId(id: appointment.patientId, success: { (response) in
            if let model = try? JSONDecoder().decode(Patient.self, from: response) {
                self.api.getUser(userId: model.userId, success: { (userResponse) in
                    if let userModel = try? JSONDecoder().decode(User.self, from: userResponse) {
                        self.patient = model
                        self.patientUser = userModel
                        patientName = userModel.firstName + " " + userModel.lastName
                    }
                }) { (error) in
                    print("failed to get user")
                }
            }
        }) { (error) in
            print("failed to get patient")
        }
        
        api.getGroupForAppointment(appointmentId: appointment.id, success: { (response) in
            if let model = try? JSONDecoder().decode(MessageGroup.self, from: response) {
                self.group = model
                self.chatButton.setTitle("Open Chat", for: .normal)
                self.chatButton.addTarget(self, action: #selector(self.openChat), for: .touchUpInside)
            }
        }) { (error) in
            print("Failed to get message group")
            self.chatButton.setTitle("Create Chat", for: .normal)
            self.chatButton.addTarget(self, action: #selector(self.createChat), for: .touchUpInside)
        }
        
        self.subLabel.text = "Appointment with \(patientName) on \(Date(timeIntervalSince1970: Double(appointment.start / 1000)).textFormat())"
        self.descriptionField.text = appointmentInfo.description
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subLabel)
        self.view.addSubview(descriptionField)
        self.view.addSubview(attachedImageView)
        self.view.addSubview(chatButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 5)
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
        }
        
        subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimensions.Padding.medium)
            make.left.right.equalTo(self.titleLabel)
        }
        
        attachedImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(250)
            make.top.equalTo(self.subLabel.snp.bottom).offset(Dimensions.Padding.large)
            make.centerX.equalTo(self.view)
        }
        
        descriptionField.snp.makeConstraints { (make) in
            make.top.equalTo(self.attachedImageView.snp.bottom).offset(Dimensions.Padding.large)
            make.left.equalTo(self.view).offset(Dimensions.Padding.large - 5)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large + 5)
            make.bottom.equalTo(self.chatButton.snp.top).offset(-Dimensions.Padding.extraLarge)
        }
        
        chatButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
    }
    
    @objc func openChat() {
        if let messageGroup = group {
            self.navigationController?.pushViewController(DoctorAppointmentChatController(user: self.user, doctor: self.doctor, messageGroup: messageGroup, appointment: self.appointment, appointmentInfo: self.appointmentInfo, patient: self.patient, patientUser: self.patientUser), animated: true)
        }
    }
    
    @objc func createChat() {
        
    }
    
}
