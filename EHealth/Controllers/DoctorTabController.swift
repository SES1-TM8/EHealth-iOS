//
//  DoctorTabController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorTabController: UITabBarController {
    
    var doctor: Doctor
    
    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeController = DoctorHomeController(doctor: self.doctor)
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home")!, tag: 1)
        
        let appointmentController = DoctorAppointmentListControllerController(doctor: self.doctor)
        appointmentController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointment"), tag: 2)
        
        let patientController = DoctorPatientListController(doctor: self.doctor)
        patientController.tabBarItem = UITabBarItem(title: "Patients", image: UIImage(named: "person"), tag: 3)
        
        
        self.viewControllers = [homeController, appointmentController, patientController]
    }
    
}
