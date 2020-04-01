//
//  UIImage+Resize.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scale(to dimension: CGFloat) -> UIImage? {
        scale(to: CGSize(width: dimension, height: dimension))
    }
    
    func scale(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
