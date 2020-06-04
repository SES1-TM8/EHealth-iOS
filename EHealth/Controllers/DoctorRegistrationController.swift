//
//  DoctorRegistrationController.swift
//  EHealth
//
//  Created by Jon McLean on 15/5/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorRegistrationController: UIViewController {
    
    let api = API.shared
    
    var user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var registrationField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Registration Number Field", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .default
        
        return field
    }()
    
     var submitButton: UIButton = {
           let button = UIButton(type: .custom)
           
           button.layer.cornerRadius = 5.0
           button.setTitle("Register", for: .normal)
           button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
           button.setTitleColor(Theme.secondary, for: .normal)
           button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
           button.addTarget(self, action: #selector(submitDoctorRegistration), for: .touchUpInside)
           
           return button
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTapAround()
        
        self.view.backgroundColor = Theme.background
        
        self.view.addSubview(registrationField)
        self.view.addSubview(submitButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        registrationField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset((-Dimensions.Padding.extraLarge * 3) - 75)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.registrationField)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 3)
        }
    }
    
    @objc func submitDoctorRegistration() {
        guard registrationField.text != nil else { return }
        
        api.registerDoctor(userId: user.userId, registration: registrationField.text!, success: { (response) in
            if let model = try? JSONDecoder().decode(DoctorAPI.self, from: response) {
                self.navigationController?.pushViewController(LoginController(), animated: true)
            }
        }) { (error) in
            print("failed")
        }
        
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
    
}
