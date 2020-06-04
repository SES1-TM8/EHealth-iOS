//
//  PatientPrescriptionController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit
import PDFKit

class PatientPrescriptionController: UIViewController {
    
    var user: User
    var patient: Patient
    var prescription: Prescription
    var medication: Medication
    
    init(user: User, patient: Patient, prescription: Prescription, medication: Medication) {
        self.user = user
        self.patient = patient
        self.prescription = prescription
        self.medication = medication
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var medicationInfo = InfoView()
    var prescriberInfo = InfoView()
    var instructionsInfo = InfoView()
    var notesLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-SemiBold", size: 16)
        label.textColor = UIColor.black
        label.text = "Notes"
        
        return label
    }()
    var notesTextView: UITextView = {
        let textView = UITextView()
        
        textView.textColor = Theme.accent
        textView.font = UIFont(name: "Oswald-Regular", size: 16)
        textView.backgroundColor = Theme.background
        textView.isEditable = false
        
        return textView
    }()
    
    var printButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.setTitle("Open Prescription", for: .normal)
        button.addTarget(self, action: #selector(openPrescription), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        medicationInfo.title = "Medication"
        medicationInfo.content = "\(medication.dosage.removeDecimal())\(medication.dosageUnit) \(medication.name)"
        
        instructionsInfo.title = "Instructions"
        instructionsInfo.content = "\(prescription.frequency.removeDecimal()) \(prescription.frequencyUnit)"
        
        notesTextView.text = prescription.notes
        
        self.view.addSubview(medicationInfo)
        self.view.addSubview(prescriberInfo)
        self.view.addSubview(instructionsInfo)
        self.view.addSubview(notesLabel)
        self.view.addSubview(notesTextView)
        self.view.addSubview(printButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Prescription"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        medicationInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 5)
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
        }
        
        prescriberInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.medicationInfo.snp.bottom).offset(Dimensions.Padding.large)
            make.left.right.equalTo(self.medicationInfo)
        }
        
        instructionsInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.prescriberInfo.snp.bottom).offset(Dimensions.Padding.large)
            make.left.right.equalTo(self.medicationInfo)
        }
        
        notesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.instructionsInfo.snp.bottom).offset(Dimensions.Padding.large)
            make.left.right.equalTo(self.medicationInfo)
        }
        
        notesTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.notesLabel.snp.bottom)
            make.left.equalTo(self.notesLabel).offset(-5)
            make.right.equalTo(self.notesLabel).offset(5)
            make.bottom.equalTo(self.printButton.snp.top).offset(-Dimensions.Padding.extraLarge)
        }
        
        printButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
    }
    
    @objc func openPrescription() {
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Print", style: .default, handler: { (action) in
            self.printPrescription()
        }))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.savePrescription()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func printPrescription() {
        let format = UIGraphicsPDFRendererFormat()
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let attributes = [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 28)]
            let medicationTitle: String = "Prescribed Medication"
            let medicationContent = self.medicationInfo.content
            // TODO Finish
        }
    }
    
    func savePrescription() {
        
    }
    
}
