//
//  RegistrationOptionController.swift
//  EHealth
//
//  Created by Jon McLean on 15/5/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class RegistrationOptionController: UIViewController {
    
    var user: User
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.text = "Are you a..."
        return label
    }()
    
    var doctorButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Doctor", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 42)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(openDoctorRegistration), for: .touchUpInside)
        
        return button
    }()
    
    var orLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.text = "OR"
        label.textAlignment = .center
        
        return label
    }()
    
    var patientButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Patient", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 42)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(openPatientRegistration), for: .touchUpInside)
        
        return button
    }()
    
    var goBackButton: UIButton = {
        let button = UIButton()
        
        button.setAttributedTitle(NSAttributedString(string: "Go back to login", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 18), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
        button.addTarget(self, action: #selector(goBackToLogin), for: .touchUpInside)
        
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        self.view.addSubview(questionLabel)
        self.view.addSubview(doctorButton)
        self.view.addSubview(orLabel)
        self.view.addSubview(patientButton)
        self.view.addSubview(goBackButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        questionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 4)
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 2)
        }
        
        doctorButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.height.equalTo(60)
            make.centerX.equalTo(self.view)
            make.top.equalTo(questionLabel.snp.bottom).offset(Dimensions.Padding.extraLarge * 2)
        }
        
        orLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(doctorButton)
            make.centerX.equalTo(self.view)
            make.top.equalTo(doctorButton.snp.bottom).offset(Dimensions.Padding.extraLarge * 2)
        }
        
        patientButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.doctorButton)
            make.centerX.equalTo(self.view)
            make.top.equalTo(orLabel.snp.bottom).offset(Dimensions.Padding.extraLarge * 2)
        }
        
        goBackButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 3)
        }
        
    }
    
    // MARK: Button Methods
    @objc func openDoctorRegistration() {
        self.navigationController?.pushViewController(DoctorRegistrationController(user: self.user), animated: true)
    }
    
    @objc func openPatientRegistration() {
        self.navigationController?.pushViewController(PatientRegistrationController(user: self.user), animated: true)
    }
    
    @objc func goBackToLogin() {
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
    
}
