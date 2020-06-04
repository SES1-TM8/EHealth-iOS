//
//  PatientHomeController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientHomeController: UIViewController {
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var session: Session?
    
    var appointments: [Appointment] = []
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-ExtraLight", size: 42)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    var viewDoctorButton = PanelButton()
    var urgentCaseButton = PanelButton()
    
    init(user: User, patient: Patient) {
        self.user = user
        self.patient = patient
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
        
        self.greetingLabel.text = "Good \(timeBasedGreeting()),"
        self.nameLabel.text = user.firstName
        
        self.view.backgroundColor = Theme.background
        
        let buttonWidth = (self.view.bounds.width / 2)  - 100
        
        viewDoctorButton = PanelButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonWidth))
        viewDoctorButton.imageView.image = UIImage(named: "view_scalable")
        viewDoctorButton.descriptorLabel.text = "View Doctors"
        
        let doctorsTap = UITapGestureRecognizer(target: self, action: #selector(showDoctors))
        viewDoctorButton.addGestureRecognizer(doctorsTap)
        
        urgentCaseButton = PanelButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonWidth))
        urgentCaseButton.imageView.image = UIImage(named: "urgent_case_scalable")
        urgentCaseButton.descriptorLabel.text = "Urgent Case"
        
        let urgentTap = UITapGestureRecognizer(target: self, action: #selector(showCases))
        urgentCaseButton.addGestureRecognizer(urgentTap)
        
        
        self.view.addSubview(greetingLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(viewDoctorButton)
        self.view.addSubview(urgentCaseButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        greetingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 4)
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 2)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.greetingLabel.snp.bottom)
            make.left.equalTo(self.greetingLabel)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
        
        viewDoctorButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 2)
            make.width.equalTo((self.view.bounds.width / 2)  - 100)
            make.height.equalTo((self.view.bounds.width / 2)  - 100)
        }
        
        urgentCaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
            make.width.equalTo((self.view.bounds.width / 2)  - 100)
            make.height.equalTo((self.view.bounds.width / 2)  - 100)
        }
    }
    
    func timeBasedGreeting() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 12 && hour < 18 {
            return "afternoon"
        }else if hour >= 5 && hour < 12 {
            return "morning"
        }else {
            return "evening"
        }
    }
    
    @objc func showDoctors() {
        self.navigationController?.pushViewController(PatientViewDoctorsController(user: self.user, patient: self.patient), animated: true)
    }
    
    @objc func showCases() {
        self.navigationController?.pushViewController(PatientUrgentCaseListController(user: self.user, patient: self.patient), animated: true)
    }
    
}
