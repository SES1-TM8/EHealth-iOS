//
//  LoginController.swift
//  EHealth
//
//  Created by Jon McLean on 31/3/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var headerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "wave")!
        imageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Welcome"
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        label.textColor = Theme.background
        
        return label
    }()
    
    var emailField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var passwordField: UnderlinedField = {
        let field = UnderlinedField()
        
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize), NSAttributedString.Key.foregroundColor : Theme.accent])
        field.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        field.tintColor = Theme.accent
        field.isSecureTextEntry = true
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        
        return field
    }()
    
    var nextLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Sign in"
        label.font = UIFont(name: "Oswald-Regular", size: 18)
        label.textColor = UIColor.black
        
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named: "next")?.scale(to: CGSize(width: 40, height: 40)), for: .normal)
        button.backgroundColor = Theme.secondary
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        return button
    }()
    
    var registerButton: UIButton = {
        let button = UIButton()
        
        button.setAttributedTitle(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 18), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
        button.addTarget(self, action: #selector(presentSignUp), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        self.hideKeyboardOnTapAround()
        
        self.view.addSubview(headerImage)
        self.view.addSubview(titleLabel)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(nextLabel)
        self.view.addSubview(nextButton)
        self.view.addSubview(registerButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerImage.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo((self.view.bounds.height / 2) - 50)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-(self.view.bounds.height / 4))
            make.width.equalTo(self.view.bounds.width - 125)
            make.centerX.equalTo(self.view)
        }
        
        emailField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 125)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 3)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 125)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.emailField.snp.bottom).offset(Dimensions.Padding.extraLarge)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(75)
            make.top.equalTo(self.passwordField.snp.bottom).offset(Dimensions.Padding.extraLarge * 4)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 4)
        }
        
        nextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 4)
            make.centerY.equalTo(self.nextButton)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.nextButton.snp.bottom).offset(Dimensions.Padding.extraLarge * 3)
        }
        
    }
    
    // MARK: - Button Methods
    @objc func signIn() { // TODO: Add Errors
        guard let email = self.emailField.text, isValidEmail(email) else { return }
        guard let password = self.passwordField.text, password.count >= 8 else { return }
        
        // TODO: Send to API
        
        let doctorVC = DoctorHomeController()
        
        self.navigationController?.pushViewController(doctorVC, animated: true)
    }
    
    @objc func presentSignUp() {
        
    }
    
    // MARK: - Other Methods
    
    private func isValidEmail(_ content: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: content)
    }
    
}
