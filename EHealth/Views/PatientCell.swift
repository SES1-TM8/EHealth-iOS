//
//  PatientCell.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientCell: UITableViewCell {
    
    private var nameCircle: InitialsCircle = {
        let circle = InitialsCircle(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        circle.backgroundColor = Theme.secondary
        circle.initials = "#"
        return circle
    }()
    
    private var patientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 19)
        return label
    }()
    
    var patientName: String? {
        get { patientLabel.text }
        set { patientLabel.text = newValue }
    }
    
    var initials: String? {
        get { nameCircle.initials }
        set { nameCircle.initials = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildCell()
    }
    
    init(reuseId: String) {
        super.init(style: .default, reuseIdentifier: reuseId)
        self.buildCell()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func buildCell() {
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(nameCircle)
        self.contentView.addSubview(patientLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameCircle.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(Dimensions.Padding.large)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(50)
        }
        
        patientLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameCircle.snp.right).offset(Dimensions.Padding.large)
            make.centerY.equalTo(self.contentView)
        }
    }
    
}
