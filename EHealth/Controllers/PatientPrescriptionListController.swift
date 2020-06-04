//
//  PatientPrescriptionListController.swift
//  EHealth
//
//  Created by Jon McLean on 3/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientPrescriptionListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "PrescriptionCell"
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var session: Session?
    var prescriptions: [Prescription] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var medications: [Int : Medication] = [:]
    
    var tableView: UITableView = UITableView()
    
    init(user: User, patient: Patient) {
        self.user = user
        self.patient = patient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        self.loadPrescriptions()
        
        tableView.backgroundColor = Theme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrescriptionCell.self, forCellReuseIdentifier: PatientPrescriptionListController.cellId)
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loadPrescriptions() {
        api.getPrescriptions(token: self.session!.token, success: { (response) in
            if let model = try? JSONDecoder().decode([Prescription].self, from: response) {
                self.prescriptions = model
                self.loadMedications()
            }
        }) { (error) in
            print("failure to get prescriptions")
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
                print("failure to get medications")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PrescriptionCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: PatientPrescriptionListController.cellId, for: indexPath) as? PrescriptionCell {
            cell = dequeue
        }else {
            cell = PrescriptionCell(reuseId: PatientPrescriptionListController.cellId)
        }
        
        cell.setPrescription(prescriptions[indexPath.row], medication: medications[prescriptions[indexPath.row].id] ?? Medication(id: 0, name: "Placeholder", inputType: "oral", dosage: 2, dosageUnit: "mg", scheduleListing: "2"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorPatientMedicationsController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let medication = self.medications[self.prescriptions[indexPath.row].id] {
            self.navigationController?.pushViewController(PatientPrescriptionController(user: self.user, patient: self.patient, prescription: self.prescriptions[indexPath.row], medication: medication), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
