//
//  DoctorPatientTabController.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorPatientTabController: UITabBarController {
    
    var user: User
    var doctor: DoctorAPI
    var patient: Patient
    
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
        
        self.tabBar.barTintColor = Theme.background
        
        let patientInfoController = DoctorPatientController(user: user, doctor: doctor, patient: patient)
        patientInfoController.tabBarItem = UITabBarItem(title: "Information", image: UIImage(named: "person"), tag: 1)
        
        let medicationsController = DoctorPatientMedicationsController(user: user, doctor: self.doctor, patient: self.patient)
        medicationsController.tabBarItem = UITabBarItem(title: "Medications", image: UIImage(named: "medications"), tag: 2)
        
        self.viewControllers = [patientInfoController, medicationsController]
    }
    
}
