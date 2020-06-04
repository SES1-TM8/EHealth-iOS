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
    
    let api = API.shared
    
    var user: User
    var doctor: DoctorAPI
    var patient: Patient
    
    var prescriptions: [Prescription] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var medications: [Int : Medication] = [:]
    
    var backButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.tintColor = UIColor.black
        
        return button
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
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
    
    init(user: User, doctor: DoctorAPI, patient: Patient) {
        self.user = user
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
        
        api.getUser(userId: patient.userId, success: { (response) in
            if let model = try? JSONDecoder().decode(User.self, from: response) {
                self.patientLabel.text = model.firstName + " " + model.lastName
            }
        }) { (error) in
            print("failed to get user")
            self.navigationController?.popViewController(animated: true)
        }
        
        
        self.view.addSubview(backButton)
        self.view.addSubview(addButton)
        self.view.addSubview(patientLabel)
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadPrescriptions()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge)
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 3)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge)
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
    
    func loadPrescriptions() {
        api.getPrescriptions(patientId: self.patient.id, success: { (response) in
            if let model = try? JSONDecoder().decode([Prescription].self, from: response) {
                self.prescriptions = model
                self.loadMedications()
            }
        }) { (error) in
            print("Failure to get prescriptions")
        }
    }
    
    func loadMedications() {
        for i in self.prescriptions {
            api.getMedication(medicationId: i.medicationId, success: { (response) in
                if let model = try? JSONDecoder().decode(Medication.self, from: response) {
                    self.medications.updateValue(model, forKey: i.id)
                    self.tableView.reloadData()
                }
            }) { (error) in
                print("Failed to medication")
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func add() {
        let vc = DoctorAddMedicationController(user: self.user, doctor: self.doctor, patient: self.patient)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true) {
            //self.tableView.reloadData()
        }
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
        
        cell.setPrescription(self.prescriptions[indexPath.row], medication: self.medications[prescriptions[indexPath.row].id] ?? Medication(id: 0, name: "Placeholder", inputType: "oral", dosage: 2, dosageUnit: "mg", scheduleListing: "2"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorPatientMedicationsController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
