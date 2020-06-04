//
//  UnderlinedTextView.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class UnderlinedTextView: UITextView {
    
    override var tintColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        //super.draw(rect)
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let bezier = UIBezierPath()
        bezier.move(to: startPoint)
        bezier.addLine(to: endPoint)
        bezier.lineWidth = 2.0
        
        tintColor.setStroke()
        bezier.stroke()
    }
    
}
