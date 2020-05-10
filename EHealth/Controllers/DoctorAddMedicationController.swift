//
//  DoctorAddMedicationController.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorAddMedicationController: UIViewController {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-ExtraLight", size: 32)
        label.textColor = UIColor.black
        label.text = "Add new medication"
        
        return label
    }()
    
    var nameField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Medicine Name", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 25), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: 25)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        return field
    }()
    
    var dosageField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Dose", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 25), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: 25)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .decimalPad
        
        return field
    }()
    
    var dosageUnitField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.text = "mg"
        field.font = UIFont(name: "Oswald-Regular", size: 25)
        field.tintColor = Theme.accent
        // field.textColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .alphabet
        
        return field
    }()
    
    var frequencyField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Frequency", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 25), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: 25)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .numberPad
        
        return field
    }()
    
    var frequencyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "per day"
        label.textAlignment = .left
        label.font = UIFont(name: "Oswald-Regular", size: 25)
        
        return label
    }()
    
    var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(submitMedication), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.background
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(nameField)
        self.view.addSubview(dosageField)
        self.view.addSubview(dosageUnitField)
        self.view.addSubview(frequencyField)
        self.view.addSubview(frequencyLabel)
        self.view.addSubview(submitButton)
        
        self.hideKeyboardOnTapAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.view).offset(Dimensions.Padding.large)
        }
        
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.height.equalTo(40)
        }
        
        dosageField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.top.equalTo(self.nameField.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.height.equalTo(self.nameField)
            make.width.equalTo(self.view.bounds.width - 75)
        }
        
        dosageUnitField.snp.makeConstraints { (make) in
            make.left.equalTo(self.dosageField.snp.right).offset(Dimensions.Padding.medium)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.dosageField)
            make.height.equalTo(self.dosageField)
        }
        
        frequencyField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.top.equalTo(self.dosageField.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.height.equalTo(self.nameField)
            make.width.equalTo(self.view.bounds.width - 150)
        }
        
        frequencyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.frequencyField.snp.right).offset(Dimensions.Padding.extraLarge)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.frequencyField)
            make.height.equalTo(self.frequencyField)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
    }
    
    // MARK: - Button Methods
    
    @objc func submitMedication() {
        // TODO: Add API calls
        self.dismiss(animated: true, completion: nil)
    }
    
}
