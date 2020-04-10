//
//  StepperView.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class StepperView: UIView {
    
    var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "add"), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = Theme.accent
        button.layer.cornerRadius = 0.5 * button.bounds.height
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addToCount), for: .touchUpInside)
        return button
    }()
    
    var minusButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "remove"), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = Theme.accent
        button.layer.cornerRadius = 0.5 * button.bounds.height
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(subtractFromCount), for: .touchUpInside)
        return button
    }()
    
    var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-Regular", size: 23)
        label.textColor = UIColor.black
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    var counter: Int = 0 {
        didSet {
            self.counterLabel.text = "\(counter)"
        }
    }
    
    init(startingNumber: Int) {
        super.init(frame: .zero)
        counter = startingNumber
        self.counterLabel.text = "\(startingNumber)"
        self.buildView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    init() {
        super.init(frame: .zero)
        self.buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        self.addSubview(addButton)
        self.addSubview(counterLabel)
        self.addSubview(minusButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        counterLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(self.counterLabel.snp.left).offset(-Dimensions.Padding.extraLarge)
            make.centerY.equalTo(self.counterLabel)
        }
        
        minusButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalTo(self.counterLabel.snp.right).offset(Dimensions.Padding.extraLarge)
            // make.right.equalTo(self)
            make.centerY.equalTo(self.counterLabel)
        }
    }
    
    @objc func addToCount() {
        print("add to counter")
        self.counter += 1
    }
    
    @objc func subtractFromCount() {
        self.counter -= 1
    }
    
}
