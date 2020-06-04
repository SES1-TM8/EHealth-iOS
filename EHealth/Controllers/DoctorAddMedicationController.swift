//
//  DoctorAddMedicationController.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorAddMedicationController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    let api = API.shared
    
    var user: User
    var doctor: DoctorAPI
    var patient: Patient
    var session: Session?
    
    init(user: User, doctor: DoctorAPI, patient: Patient) {
        self.user = user
        self.doctor = doctor
        self.patient = patient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedConsumption: ConsumptionMethod?
    
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
        field.keyboardType = .default
        
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
    
    var inputField: UnderlinedField = {
        let field = UnderlinedField()
        field.attributedPlaceholder = NSAttributedString(string: "Input Method", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 25), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: 25)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .numberPad
        return field
    }()
    
    var notesField: UnderlinedTextView = {
        let textView = UnderlinedTextView()
        
        textView.tintColor = Theme.accent
        textView.text = "Notes"
        textView.textColor = Theme.accent
        textView.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        
        return textView
    }()
    
    var inputPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.background
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        inputPicker.delegate = self
        inputPicker.dataSource = self
        
        inputField.inputView = inputPicker
        
        notesField.delegate = self
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(nameField)
        self.view.addSubview(dosageField)
        self.view.addSubview(dosageUnitField)
        self.view.addSubview(frequencyField)
        self.view.addSubview(frequencyLabel)
        self.view.addSubview(inputField)
        self.view.addSubview(notesField)
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
        
        inputField.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameField)
            make.top.equalTo(frequencyField.snp.bottom).offset(Dimensions.Padding.large)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
        
        notesField.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputField)
            make.top.equalTo(inputField.snp.bottom).offset(Dimensions.Padding.large)
            make.bottom.equalTo(submitButton.snp.top).offset(-Dimensions.Padding.large)
        }
    }
    
    // MARK: - Button Methods
    
    @objc func submitMedication() {
        guard let name = nameField.text, let input = selectedConsumption?.rawValue, let dosage = Double(self.dosageField.text ?? ""), let dosageUnit = self.dosageUnitField.text else { return }
        guard let frequency = Double(self.frequencyField.text ?? "") else { return }
        api.createMedication(name: name, input: input, dosage: dosage, dosageUnit: dosageUnit, schedule: 2, success: { (response) in
            if let model = try? JSONDecoder().decode(Medication.self, from: response) {
                self.api.createPrescription(patientId: self.patient.id, medicationId: model.id, frequency: frequency, frequencyUnit: "day", notes: self.notesField.text, token: self.session!.token, success: { (response) in
                    
                    if let prescriptionModel = try? JSONDecoder().decode(Prescription.self, from: response) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }) { (error) in
                    print("failed to create prescription")
                }
            }
        }) { (error) in
            print("Failed to create medication")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConsumptionMethod.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConsumptionMethod.allCases[row].displayName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedConsumption = ConsumptionMethod.allCases[row]
        self.inputField.text = self.selectedConsumption?.displayName()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" && textView.textColor == Theme.accent {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Notes"
            textView.textColor = Theme.accent
        }
    }
    
}
