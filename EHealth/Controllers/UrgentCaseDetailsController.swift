//
//  UrgentCaseDetailsController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class UrgentCaseDetailsController: UIViewController {
    
    var urgentCase: UrgentCase
    
    init(urgentCase: UrgentCase) {
        self.urgentCase = urgentCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var descriptionField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = Theme.background
        textView.text = "Injury Description"
        textView.textColor = UIColor.black
        textView.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        textView.isEditable = false
        return textView
    }()
    
    var attachImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.imageFromServerURL(urlString: "https://ehealthcare-uts.s3-ap-southeast-2.amazonaws.com/15912484261172769499e-c463-4ece-86ec-b435a2cd3b66.jpeg")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        self.descriptionField.text = urgentCase.description
        
        super.view.addSubview(descriptionField)
        super.view.addSubview(attachImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        attachImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
        }
        
        descriptionField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 2)
            make.left.right.equalTo(attachImageView)
            make.bottom.equalTo(attachImageView.snp.top).offset(-Dimensions.Padding.large)
        }
    }
    
}

extension UIImageView {
    func imageFromServerURL(urlString: String) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
      }
}
