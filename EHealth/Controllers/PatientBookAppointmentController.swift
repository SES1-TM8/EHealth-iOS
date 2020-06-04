//
//  PatientBookAppointmentController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientBookAppointmentController: UIViewController, UITextViewDelegate {
    
    let api = API.shared
    
    var selectedDate: Date = Date()
    
    var user: User
    var patient: Patient
    var doctor: DoctorAPI
    
    var session: Session?
    
    var timePicker = UIDatePicker()
    
    var timeField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Appointment Time", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        return field
    }()
    
    var descriptionField: UnderlinedTextView = {
        let textView = UnderlinedTextView()
        
        textView.tintColor = Theme.accent
        textView.text = "Injury Description"
        textView.textColor = Theme.accent
        textView.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        
        return textView
    }()
    
    var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Book Appointment", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        return button
    }()
    
    init(user: User, patient: Patient, doctor: DoctorAPI) {
        self.user = user
        self.patient = patient
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        self.hideKeyboardOnTapAround()
        
        descriptionField.delegate = self
        
        timeField.inputView = timePicker
        
        timePicker.addTarget(self, action: #selector(changeTime(_:)), for: .valueChanged)
        
        descriptionField.delegate = self
        
        self.view.backgroundColor  = Theme.background
        
        self.view.addSubview(timeField)
        self.view.addSubview(descriptionField)
        self.view.addSubview(nextButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 5)
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
        
        descriptionField.snp.makeConstraints { (make) in
            make.left.equalTo(timeField)
            make.right.equalTo(timeField)
            make.top.equalTo(timeField.snp.bottom).offset(Dimensions.Padding.large)
            make.bottom.equalTo(nextButton.snp.top).offset(-Dimensions.Padding.large)
        }
    }
    
    @objc func changeTime(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        
        if let day = components.day, let month = components.month, let year = components.year, let hour = components.hour, let minute = components.minute {
            timeField.text = "\(hour):\(minute) on \(day)/\(month)/\(year)"
        }
        
        self.selectedDate = sender.date
    }
    
    @objc func nextPage() {
        api.createAppointment(token: session!.token, doctorId: doctor.doctorId, startTimestamp: Int(self.selectedDate.timeIntervalSince1970 * 1000), success: { (response) in
            if let model = try? JSONDecoder().decode(Appointment.self, from: response) {
                self.navigationController?.pushViewController(PatientAttachImageController(user: self.user, patient: self.patient, doctor: self.doctor, appointment: model, desc: self.descriptionField.text), animated: true)
            }
        }) { (error) in
            print("failure")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Injury Description" && textView.textColor == Theme.accent {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Injury Description"
            textView.textColor = Theme.accent
        }
    }
    
    
}
