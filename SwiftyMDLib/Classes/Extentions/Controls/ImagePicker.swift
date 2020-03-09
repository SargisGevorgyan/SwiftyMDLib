//
//  ImagePicker.swift
//  PersonalLawyer
//
//  Created by Davit Ghushchyan on 7/18/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
import AVFoundation

protocol CanPresent: class {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

protocol ImagePickerAlertControllerDelegate: CanPresent {
    func imagePickerAlertController(_ imagePicker: ImagePickerAlertController, didSelected image: UIImage?)
}


open class ImagePickerAlertController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CanPresent {
    
    private var imagePicker = UIImagePickerController()
    
    weak var delegate: ImagePickerAlertControllerDelegate?
    var isCropperRequired = true
    
    
    func openAlert() {
        let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
        let openGalleryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            print("Gallery Open")
            self.openGallery()
        }
        let openCameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        alert.addAction(openCameraAction)
        alert.addAction(openGalleryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = isCropperRequired
            delegate?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openCamera() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraFlashMode = .auto
        imagePicker.cameraDevice = .rear
        imagePicker.allowsEditing = isCropperRequired
        imagePicker.setEditing(true, animated: true)
        PermissionManager.permissionForCamera(delegate ?? self, picker: imagePicker)
        
    }
    
    private func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        print("Image Picked")
        delegate?.imagePickerAlertController(self, didSelected: image)
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[.originalImage] as? UIImage
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        }
        print("Selected Image Path is: \n assets-library://asset/asset.HEIC?id=E0BFE0C9-4C02-42C2-A308-3F8AF32EFAD8&ext=HEIC")
        delegate?.imagePickerAlertController(self, didSelected: image)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Picking")
        delegate?.dismiss(animated: true, completion: nil)
    }
}
