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
    
    var amountStepper: StepperView = {
        let stepper = StepperView(startingNumber: 0)
        
        return stepper
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.background
        
        amountStepper.isUserInteractionEnabled = true
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(nameField)
        self.view.addSubview(amountStepper)
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
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimensions.Padding.large)
            make.height.equalTo(40)
        }
        
        amountStepper.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(self.view)
        }
    }
    
}
