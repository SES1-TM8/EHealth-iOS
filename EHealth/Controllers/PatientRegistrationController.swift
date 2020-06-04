//
//  PatientRegistrationController.swift
//  EHealth
//
//  Created by Jon McLean on 19/5/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientRegistrationController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let api = API.shared
    
    var user: User
    
    var selectedConcession: ConcessionType = .none
    
    let concessionPicker = UIPickerView()
    
    var concessionTypeField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Concession Type", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        
        return field
    }()
    
    var concessionNumberField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Concession Number", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .default
        field.isEnabled = false
        
        return field
    }()
    
    var medicareNumberField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Medicare Number", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
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
        button.addTarget(self, action: #selector(submitPatientRegistration), for: .touchUpInside)
        
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
        
        self.hideKeyboardOnTapAround()
        
        self.view.backgroundColor = Theme.background
        
        concessionPicker.dataSource = self
        concessionPicker.delegate = self
        
        concessionTypeField.inputView = concessionPicker
        
        self.view.addSubview(concessionTypeField)
        self.view.addSubview(concessionNumberField)
        self.view.addSubview(medicareNumberField)
        self.view.addSubview(submitButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.concessionTypeField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset((-Dimensions.Padding.extraLarge * 3) - 75)
        }
        
        self.concessionNumberField.snp.makeConstraints { (make) in
            make.width.equalTo(self.concessionTypeField)
            make.height.equalTo(self.concessionTypeField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.concessionTypeField.snp.bottom).offset(Dimensions.Padding.extraLarge)
        }
        
        self.medicareNumberField.snp.makeConstraints { (make) in
            make.width.equalTo(self.concessionTypeField)
            make.height.equalTo(self.concessionTypeField)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.concessionNumberField.snp.bottom).offset(Dimensions.Padding.extraLarge)
        }
        
        self.submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.medicareNumberField)
            make.height.equalTo(self.medicareNumberField)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 3)
        }
        
    }
    
    @objc func submitPatientRegistration() {
        guard concessionTypeField.text != nil && concessionNumberField.text != nil && medicareNumberField != nil else { return }
        
        api.registerPatient(concessionType: selectedConcession, concessionNumber: concessionNumberField.text!, medicareNumber: medicareNumberField.text!, userId: self.user.userId, success: { (response) in
            
            if let model = try? JSONDecoder().decode(Patient.self, from: response) {
                let vc = LoginController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (error) in
            print("failure")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConcessionType.allCases.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConcessionType.allCases[row].displayName()
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        concessionTypeField.text = ConcessionType.allCases[row].displayName()
        
        self.selectedConcession = ConcessionType.allCases[row]
        
        if(ConcessionType.allCases[row] == .none) {
            concessionNumberField.isEnabled = false
            concessionNumberField.text = ""
        }else {
            concessionNumberField.isEnabled = true
            concessionNumberField.text = ""
        }
    }
    
    
}
