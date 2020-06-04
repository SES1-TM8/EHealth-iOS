//
//  OtherController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class OtherController: UIViewController {
    
    var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        self.view.addSubview(logoutButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.large * 4)
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
    @objc func logoutUser() {
        let defaults = UserDefaults()
        defaults.removeObject(forKey: "ehealth_user")
        defaults.removeObject(forKey: "ehealth_session")
        defaults.removeObject(forKey: "ehealth_doctor")
        defaults.removeObject(forKey: "ehealth_patient")
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
    
}
