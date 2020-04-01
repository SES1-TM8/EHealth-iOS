//
//  DoctorPatientMedicationsController.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorPatientMedicationsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "PrescriptionCell"
    static let cellHeight: CGFloat = 80
    
    var doctor: Doctor
    var patient: Patient
    
    var prescriptions: [Prescription] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.tintColor = UIColor.black
        
        return button
    }()
    
    var patientLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    var tableView = UITableView()
    
    init(doctor: Doctor, patient: Patient) {
        self.doctor = doctor
        self.patient = patient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.background
        tableView.backgroundColor = UIColor.clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrescriptionCell.self, forCellReuseIdentifier: DoctorPatientMedicationsController.cellId)
        
        patientLabel.text = self.patient.name
        
        
        self.view.addSubview(backButton)
        self.view.addSubview(patientLabel)
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.prescriptions = [Prescription(id: 0, prescribedBy: self.doctor, prescribedTo: self.patient, medication: Medication(id: 0, name: "Prednisolone", consumption: .oral), dosage: 25.0, amount: 3, perUnit: .day, prescriptionDate: 1585753413)]
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge)
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 3)
        }
        
        patientLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.backButton)
            make.top.equalTo(self.backButton.snp.bottom).offset(Dimensions.Padding.extraLarge)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.patientLabel.snp.bottom).offset(Dimensions.Padding.medium)
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableView Delegate/DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrescriptionCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorPatientMedicationsController.cellId, for: indexPath) as? PrescriptionCell {
            cell = dequeue
        }else {
            cell = PrescriptionCell(reuseId: DoctorPatientMedicationsController.cellId)
        }
        
        cell.setPrescription(self.prescriptions[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorPatientMedicationsController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
