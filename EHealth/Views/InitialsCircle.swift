//
//  InitialsCircle.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class InitialsCircle: UIView {
    
    private var initialsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.white
        return label
    }()
    
    var initials: String? {
        get { initialsLabel.text }
        set { initialsLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = frame.height * 0.5
        self.clipsToBounds = true
        
        self.addSubview(initialsLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        initialsLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
}
