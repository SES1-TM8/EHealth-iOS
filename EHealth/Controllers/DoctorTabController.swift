//
//  DoctorTabController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorTabController: UITabBarController {
    
    var user: User
    var doctor: DoctorAPI
    
    init(user: User, doctor: DoctorAPI) {
        self.user = user
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = Theme.background
        
        let homeController = DoctorHomeController(user: user, doctor: doctor)
        homeController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home")!, tag: 1)
        
        let appointmentController = DoctorAppointmentListControllerController(user: user, doctor: self.doctor)
        appointmentController.tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointment"), tag: 2)
        
        let patientController = DoctorPatientListController(user: user, doctor: self.doctor)
        patientController.tabBarItem = UITabBarItem(title: "Patients", image: UIImage(named: "person"), tag: 3)
        
        let urgentController = DoctorUrgentCaseListController(user: user, doctor: doctor)
        urgentController.tabBarItem = UITabBarItem(title: "Urgent Cases", image: UIImage(named: "urgent_case_scalable"), tag: 4)
        
        let otherController = OtherController()
        otherController.tabBarItem = UITabBarItem(title: "Other", image: UIImage(named: "more"), tag: 5)
        
        self.viewControllers = [homeController, appointmentController, patientController, urgentController, otherController]
    }
    
}
