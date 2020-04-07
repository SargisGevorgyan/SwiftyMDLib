//
//  ImagePicker.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
import AVFoundation

public protocol CanPresent: class {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

public protocol ImagePickerAlertControllerDelegate: CanPresent {
    func imagePickerAlertController(_ imagePicker: ImagePickerAlertController, didSelected image: UIImage?)
}


open class ImagePickerAlertController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CanPresent {
    
    private var imagePicker = UIImagePickerController()
    
    open weak var delegate: ImagePickerAlertControllerDelegate?
    var isCropperRequired = true
    
    var deleteImageAction: (()->())?
    
    open func openAlert(isDeleteRequired: Bool = false) {
        let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
        let openGalleryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            print("Gallery Open")
            self.openGallery()
        }
        let openCameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        let deleteActin = UIAlertAction(title: "title_delete_photo".localize(), style: .destructive) { (_) in
            self.deleteImageAction?()
        }
        
        if isDeleteRequired {
            alert.addAction(deleteActin)
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
        delegate?.dismiss(animated: true, completion: nil)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Picking")
        delegate?.dismiss(animated: true, completion: nil)
    }
}
