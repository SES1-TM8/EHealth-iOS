//
//  PatientCreateCaseController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit
import Alamofire

class PatientCreateCaseController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var session: Session?
    
    init(user: User, patient: Patient) {
        self.user = user
        self.patient = patient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var descriptionField: UnderlinedTextView = {
        let textView = UnderlinedTextView()
        
        textView.tintColor = Theme.accent
        textView.text = "Injury Description"
        textView.textColor = Theme.accent
        textView.font = UIFont(name: "Oswald-Regular", size: UIFont.labelFontSize)
        
        return textView
    }()
    
    var attachedImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var attachImageButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Attach Image", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(attachImage), for: .touchUpInside)
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(submitCase), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        self.hideKeyboardOnTapAround()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        descriptionField.delegate = self
        
        self.view.addSubview(attachedImageView)
        self.view.addSubview(nextButton)
        self.view.addSubview(attachImageButton)
        self.view.addSubview(descriptionField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
        
        attachImageButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nextButton.snp.top).offset(-Dimensions.Padding.large)
            make.width.equalTo(nextButton)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        attachedImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.bottom.equalTo(self.attachImageButton.snp.top).offset(-Dimensions.Padding.large)
            make.centerX.equalTo(self.view)
        }
        
        descriptionField.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 5)
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
            make.bottom.equalTo(attachedImageView.snp.top).offset(-Dimensions.Padding.large)
        }
        
    }
    
    @objc func submitCase() {
        api.postUrgentCase(token: self.session!.token, description: self.descriptionField.text, mimeType: "image/jpeg", success: { (response) in
            if let model = try? JSONDecoder().decode(UrgentCaseCallbackResponse.self, from: response) {
                for i in 0..<model.uploads.count {
                    if let data = self.attachedImageView.image?.jpegData(compressionQuality: 1.0) {
                        print(model.uploads[i].uploadUrl)
                        Alamofire.upload(data, to: model.uploads[i].uploadUrl, method: .put, headers: ["Content-Type": "image/jpeg"]).responseData { (dataResponse) in
                            self.api.createMessageGroup(direct: true, name: "", memberId: self.user.userId, token: self.session!.token, appointmentId: model.id, success: { (response) in
                                if let model = try? JSONDecoder().decode(MessageGroup.self, from: response) {
                                    self.navigationController?.pushViewController(PatientTabController(patient: self.patient, user: self.user), animated: true)
                                }
                            }) { (error) in
                                print("failure to create message group")
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print("failure to post urgent case")
        }
    }
    
    @objc func attachImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        let actionSheetController = UIAlertController(title: "Source", message: "Where do you want to import the image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(libraryAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.attachedImageView.image = image
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Injury Description" && textView.textColor == Theme.accent {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Injury Description"
            textView.textColor = Theme.accent
        }
    }
    
}
