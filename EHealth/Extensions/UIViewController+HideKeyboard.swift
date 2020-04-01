//
//  UIViewController+HideKeyboard.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardOnTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
