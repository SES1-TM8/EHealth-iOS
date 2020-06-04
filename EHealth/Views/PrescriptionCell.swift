//
//  PrescriptionCell.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PrescriptionCell: UITableViewCell {
    
    private var medicationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 19)
        label.textColor = UIColor.black
        return label
    }()
    
    private var takenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 19)
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    var instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 15)
        label.textColor = UIColor.black
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
        
        self.contentView.addSubview(medicationLabel)
        self.contentView.addSubview(takenLabel)
        self.contentView.addSubview(instructionsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        medicationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(Dimensions.Padding.large)
            make.top.equalTo(self.contentView).offset(Dimensions.Padding.medium)
        }
        
        instructionsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.medicationLabel)
            make.top.equalTo(self.medicationLabel.snp.bottom).offset(Dimensions.Padding.medium)
        }
        
        takenLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.instructionsLabel.snp.right).offset(Dimensions.Padding.medium)
            make.right.equalTo(self.contentView).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.medicationLabel)
            make.bottom.equalTo(self.contentView).offset(-Dimensions.Padding.medium)
        }
    }
    
    func setPrescription(_ prescription: Prescription, medication: Medication) {
        self.medicationLabel.text = "\(medication.dosage.removeDecimal())\(medication.dosageUnit) \(medication.name)"
        self.instructionsLabel.text = "\(prescription.frequency) per \(prescription.frequencyUnit)"
        self.takenLabel.text = "Taken \(ConsumptionMethod(rawValue: medication.inputType)?.description() ?? "orally")"
    }
    
}

extension Double {
    func removeDecimal() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return String(formatter.string(from: number) ?? "")
    }
}
