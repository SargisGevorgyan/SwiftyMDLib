//
//  ImagePicker.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import AVFoundation
import UIKit

public protocol CanPresent: class {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

public protocol ImagePickerAlertControllerDelegate: CanPresent {
    func imagePickerAlertController(_ imagePicker: ImagePickerAlertController, didSelected image: UIImage?)
}

open class ImagePickerAlertController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CanPresent {
    private var imagePicker = UIImagePickerController()

    open weak var delegate: ImagePickerAlertControllerDelegate?
    var isCropperRequired = true

    open var deleteImageAction: (() -> Void)?

    open func openAlert(isDeleteRequired: Bool = false) {
        let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
        let openGalleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            print("Gallery Open")
            self.openGallery()
        }
        let openCameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }

        let deleteActin = UIAlertAction(title: "title_delete_photo".localize(), style: .destructive) { _ in
            self.deleteImageAction?()
        }

        alert.addAction(openCameraAction)
        alert.addAction(openGalleryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if isDeleteRequired {
            alert.addAction(deleteActin)
        }
        delegate?.present(alert, animated: true, completion: nil)
    }

    private func openGallery() {
        PermissionManager.requestPhotoLibraryAuthorzationStatusWithCompletionHandler {

            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = self.isCropperRequired
                self.delegate?.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }

    private func openCamera() {
        PermissionManager.requestCameraRollAuthorzationStatus {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraFlashMode = .auto
            self.imagePicker.cameraDevice = .rear
            self.imagePicker.allowsEditing = self.isCropperRequired
            self.imagePicker.setEditing(true, animated: true)
            self.delegate?.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    private func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        print("Image Picked")
        delegate?.imagePickerAlertController(self, didSelected: image)
        delegate?.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
