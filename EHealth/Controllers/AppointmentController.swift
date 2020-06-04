//
//  AppointmentController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class AppointmentController: UIViewController {
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var appointment: Appointment
    var appointmentInformation: AppointmentInformation
    var messageGroup: MessageGroup?
    var doctor: DoctorAPI?
    var doctorUser: User?
    
    init(user:User, patient:Patient, appointment:Appointment, info: AppointmentInformation) {
        self.user = user
        self.patient = patient
        self.appointment = appointment
        self.appointmentInformation = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    var chatButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        var doctorName = "a doctor"
        
        api.getDoctor(doctorId: appointment.doctorId, success: { (response) in
            if let model = try? JSONDecoder().decode(DoctorAPI.self, from: response) {
                self.api.getUser(userId: model.userId, success: { (userResponse) in
                    if let userModel = try? JSONDecoder().decode(User.self, from: userResponse) {
                        self.doctor = model
                        self.doctorUser = userModel
                        doctorName = userModel.firstName + userModel.lastName
                    }
                }) { (error) in
                    print("failed to get user")
                }
            }
        }) { (error) in
            print("failure")
        }
        
        api.getGroupForAppointment(appointmentId: appointment.id, success: { (response) in
            if let model = try? JSONDecoder().decode(MessageGroup.self, from: response) {
                self.messageGroup = model
                self.chatButton.setTitle("Open Chat", for: .normal)
                self.chatButton.addTarget(self, action: #selector(self.openChat), for: .touchUpInside)
            }
        }) { (error) in
            print("Failed to get message group")
            self.chatButton.setTitle("Create Chat", for: .normal)
            self.chatButton.addTarget(self, action: #selector(self.createChat), for: .touchUpInside)
        }
        
        subLabel.text = "Appointment with \(doctorName) on \(Date(timeIntervalSince1970: Double(appointment.start / 1000)).textFormat())"
        
        descriptionField.text = appointmentInformation.description
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subLabel)
        self.view.addSubview(descriptionField)
        self.view.addSubview(chatButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        descriptionField.snp.makeConstraints { (make) in
            make.top.equalTo(self.subLabel.snp.bottom).offset(Dimensions.Padding.large)
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
        guard let mg = self.messageGroup else { return }
        
        self.navigationController?.pushViewController(PatientAppointmentChatController(user: self.user, patient: self.patient, messageGroup: mg, appointment: self.appointment, appointmentInfo: self.appointmentInformation, doctor: self.doctor, doctorUser: self.doctorUser), animated: true)
    }
    
    @objc func createChat() {
        
    }
    
}

extension Date {
    func textFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter.string(from: self)
    }
}
