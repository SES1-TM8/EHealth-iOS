//
//  DoctorPatientTabController.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorPatientTabController: UITabBarController {
    
    var doctor: Doctor
    var patient: Patient
    
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
        
        self.tabBar.barTintColor = Theme.background
        
        let patientInfoController = DoctorPatientController(doctor: doctor, patient: patient)
        patientInfoController.tabBarItem = UITabBarItem(title: "Information", image: UIImage(named: "person"), tag: 1)
        
        let medicationsController = DoctorPatientMedicationsController(doctor: self.doctor, patient: self.patient)
        medicationsController.tabBarItem = UITabBarItem(title: "Medications", image: UIImage(named: "medications"), tag: 2)
        
        self.viewControllers = [patientInfoController, medicationsController]
    }
    
}
