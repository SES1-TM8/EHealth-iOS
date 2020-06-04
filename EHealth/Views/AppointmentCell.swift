//
//  AppointmentCell.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
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
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-Regular", size: 19)
        label.textAlignment = .right
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
    
    func buildCell() {
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(nameCircle)
        self.contentView.addSubview(patientLabel)
        self.contentView.addSubview(timeLabel)
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
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.patientLabel).offset(Dimensions.Padding.large)
            make.right.equalTo(self.contentView).offset(-Dimensions.Padding.large)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTime(date: Date) {
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        var timeExtension: String
        
        if hour > 12 {
            timeExtension = "PM"
            hour = hour - 12
        }else {
            timeExtension = "AM"
        }
        
        self.timeLabel.text = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date)) at "
        
        if minute < 10 {
            self.timeLabel.text! += "\(hour):0\(minute) \(timeExtension)"
        }else {
            self.timeLabel.text! += "\(hour):\(minute) \(timeExtension)"
        }
    }
    
    
}
