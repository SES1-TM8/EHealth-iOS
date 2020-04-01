//
//  InfoView.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-SemiBold", size: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var content: String? {
        get { infoLabel.text }
        set { infoLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildCell()
    }
    
    init() {
        super.init(frame: .zero)
        self.buildCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildCell() {
        self.backgroundColor = UIColor.clear
        self.addSubview(titleLabel)
        self.addSubview(infoLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    
}
