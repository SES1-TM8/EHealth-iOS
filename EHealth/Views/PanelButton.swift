//
//  PanelButton.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PanelButton: UIView {
    
    var imageView: UIImageView = {
        let v = UIImageView()
        
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    var  descriptorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
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
        self.addSubview(imageView)
        self.addSubview(descriptorLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo((self.bounds.width / 3) * 2)
        }
        
        descriptorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp.bottom).offset(Dimensions.Padding.large)
            make.width.equalTo(imageView)
        }
    }
    
}
