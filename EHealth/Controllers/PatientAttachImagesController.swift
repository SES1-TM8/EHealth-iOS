//
//  PatientAttachImagesController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit
import Alamofire

class PatientAttachImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let cellId = "ImageCell"
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var doctor: DoctorAPI
    var appointment: Appointment
    var injuryDesc: String
    
    var session: Session?
    
    var images: [UIImage] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Attach Image", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(attachImage), for: .touchUpInside)
        
        return button
    }()
    
    var collectionView: UICollectionView!
    
    var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(submitImages), for: .touchUpInside)
        
        return button
    }()
    
    init(user: User, patient: Patient, doctor: DoctorAPI, appointment: Appointment, desc: String) {
        self.user = user
        self.patient = patient
        self.doctor = doctor
        self.appointment = appointment
        self.injuryDesc = desc
        super.init(nibName: nil, bundle: nil)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        self.view.backgroundColor = Theme.background
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = Theme.background
        self.collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: PatientAttachImageController.cellId)
        
        self.view.addSubview(nextButton)
        self.view.addSubview(collectionView)
        self.view.addSubview(submitButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 5)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
            make.top.equalTo(self.nextButton.snp.bottom).offset(Dimensions.Padding.large)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
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
    
    @objc func submitImages() {
        
        var mimes: [String] = []
        
        for _ in 0..<images.count {
            mimes.append("image/jpeg")
        }
        
        api.createAppointmentInfo(token: session!.token, appointmentId: appointment.id, description: self.injuryDesc, mimeTypes: mimes, success: { (response) in
            _ = try! JSONDecoder().decode(AppointmentResponse.self, from: response)
            if let model = try? JSONDecoder().decode(AppointmentResponse.self, from: response) {
                for i in 0..<model.uploads.count {
                    if let data = self.images[i].jpegData(compressionQuality: 1.0) {
                        print(model.uploads[i].uploadUrl)
                        Alamofire.upload(data, to: model.uploads[i].uploadUrl, method: .put, headers: ["Content-Type": "image/jpeg"]).responseData { (dataResponse) in
                            
                            /*if dataResponse.response?.statusCode == 200 {
                                print(model.uploads[i].callbackUrl)
                                self.api.imageCallback(callbackUrl: model.uploads[i].callbackUrl, success: { (response) in
                                    print("success")
                                }) { (error) in
                                    print("Fail")
                                }
                            }*/
                        }
                    }
                }
            }
        }) { (error) in
            print("failure")
        }
        api.createMessageGroup(direct: true, name: "", memberId: user.userId, token: session!.token, appointmentId: self.appointment.id, success: { (success) in
            if let model = try? JSONDecoder().decode(MessageGroup.self, from: success) {
                print("created")
                let combined = MessageGroupCombined(group: model, appointmentId: self.appointment.id)
                MessageGroupCombined.save(combined: combined)
                
                print(model.appointmentId)
                
                self.navigationController?.pushViewController(PatientTabController(patient: self.patient, user: self.user), animated: true)
            }
        }) { (error) in
            print("failure")
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.images.append(image)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PatientAttachImageController.cellId, for: indexPath) as! ImageCollectionCell
        
        cell.imageView.image = self.images[indexPath.row]
        
        return cell
    }
    
    private func mimeType(data: Data) -> String{
        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
    
}
