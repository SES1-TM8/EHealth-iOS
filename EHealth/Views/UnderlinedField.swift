//
//  UnderlinedField.swift
//  EHealth
//
//  Created by Jon McLean on 31/3/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class UnderlinedField: UITextField {
    private let shapeLayer = CAShapeLayer()
    
    override var tintColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
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
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
