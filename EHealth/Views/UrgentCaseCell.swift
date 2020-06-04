//
//  UrgentCaseCell.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class UrgentCaseCell: UITableViewCell {
    
    private var patientName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 19)
        label.textColor = UIColor.black
        return label
    }()
    
    private var resolvedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
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
        
        self.contentView.addSubview(patientName)
        self.contentView.addSubview(resolvedLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        patientName.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(Dimensions.Padding.large)
            make.top.equalTo(self.contentView).offset(Dimensions.Padding.medium)
            make.bottom.equalTo(self.contentView).offset(-Dimensions.Padding.large)
        }
        
        resolvedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.patientName.snp.right).offset(Dimensions.Padding.medium)
            make.right.equalTo(self.contentView).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.patientName)
            make.bottom.equalTo(self.contentView).offset(-Dimensions.Padding.medium)
        }
    }
    
    func setUrgentCase(urgentCase: UrgentCase, patientUser: User) {
        patientName.text = "Urgent case for \(patientUser.firstName) \(patientUser.lastName)"
        resolvedLabel.text = urgentCase.resolved ? "Resolved" : "Unresolved"
    }
}
