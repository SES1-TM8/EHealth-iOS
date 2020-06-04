//
//  PatientTabController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientTabController: UITabBarController {
    
    var patient: Patient
    var user: User
    
    init(patient: Patient, user: User) {
        self.patient = patient
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = Theme.background
        
        let homeController = PatientHomeController(user: user, patient: patient)
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        
        let appointmentController = PatientAppointmentListController(user: user, patient: patient)
        appointmentController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointment"), tag: 1)
        
        let prescriptionController = PatientPrescriptionListController(user: user, patient: patient)
        prescriptionController.tabBarItem = UITabBarItem(title: "Prescriptions", image: UIImage(named: "medications"), tag: 2)
        
        let otherController = OtherController()
        otherController.tabBarItem = UITabBarItem(title: "Other", image: UIImage(named: "more"), tag: 3)
        
        self.viewControllers = [homeController, appointmentController, prescriptionController, otherController]
        
    }
    
}
