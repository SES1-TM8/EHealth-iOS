//
//  RegistrationController.swift
//  EHealth
//
//  Created by Jon McLean on 11/5/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    let api = API.shared
    
    var selectedDate: Date?
    
    var headerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "wave")!
        imageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.text = "Register"
        return label
    }()
    
    var firstNameField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .words
        field.keyboardType = .default
        
        return field
    }()
    
    var lastNameField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .words
        field.keyboardType = .default
        
        return field
    }()
    
    var phoneNumberField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .words
        field.keyboardType = .decimalPad
        
        return field
    }()
    
    var emailField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var passwordField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.isSecureTextEntry = true
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.date = Date()
        picker.addTarget(self, action: #selector(datePicked(_:)), for: .valueChanged)
        picker.datePickerMode = .date
        
        return picker
    }()
    
    var birthField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Date Of Birth", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        return field
    }()
    
    var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(continueRegistration), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.hideKeyboardOnTapAround()
        
        self.view.backgroundColor = Theme.background
        
        birthField.inputView = datePicker
        
        self.view.addSubview(headerImage)
        self.view.addSubview(titleLabel)
        self.view.addSubview(firstNameField)
        self.view.addSubview(lastNameField)
        self.view.addSubview(phoneNumberField)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(birthField)
        self.view.addSubview(continueButton)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        
        headerImage.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo((self.view.bounds.height / 2) - 50)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-(self.view.bounds.height / 4) - 100)
            make.width.equalTo(self.view.bounds.width - 125)
            make.centerX.equalTo(self.view)
        }
        
        firstNameField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset((-Dimensions.Padding.extraLarge * 3) - 75)
        }
        
        lastNameField.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.firstNameField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(firstNameField.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        phoneNumberField.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.firstNameField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(lastNameField.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        emailField.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.firstNameField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(phoneNumberField.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.firstNameField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(emailField.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        birthField.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.firstNameField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(passwordField.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.firstNameField)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 3)
        }
    }
    
    @objc func continueRegistration() { // TODO: Add field checks
        guard emailField.text != nil && passwordField.text != nil && firstNameField.text != nil && lastNameField.text != nil && phoneNumberField.text != nil && birthField.text != nil && selectedDate != nil else { return }
        
        
        
        api.registerUser(email: emailField.text!, password: passwordField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, phoneNumber: phoneNumberField.text!, dob: selectedDate!, success: { (response) in
            print("success")
            print(response)
            
            if let model = try? JSONDecoder().decode(User.self, from: response) {
                let vc = RegistrationOptionController(user: model)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (error) in
            print("failure")
            print(error?.localizedDescription)
            
            if(error == nil) {
                print("Unknown error")
            }
        }
        
    }
    
    @objc func datePicked(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            self.birthField.text = "\(day)/\(month)/\(year)"
            self.selectedDate = sender.date
        }
    }
    
}
