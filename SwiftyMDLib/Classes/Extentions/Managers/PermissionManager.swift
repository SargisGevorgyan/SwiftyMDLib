//
//  PermissionManager.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


open class PermissionManager {
    static let shared = PermissionManager()
    
    
    private init(){}
    
    public static func permissionForCamera(_ vc: CanPresent, picker: UIImagePickerController) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized, .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success { // if request is granted (success is true)
                    DispatchQueue.main.async {
                        vc.present(picker, animated: true, completion: nil)
                    }
                } else { // if request is denied (success is false)
                    // Create Alert
                    self.openSettings()
                }
            }
        case .denied, .restricted:
            self.openSettings()
        default: break
        }
        
    }
    
    
    
    static func openSettings(_ isForCamera : Bool! = true) {
        DispatchQueue.main.async {
            let message: String = Bundle.main.object(forInfoDictionaryKey: (isForCamera ?  "NSCameraUsageDescription" : "NSPhotoLibraryUsageDescription")) as! String
            
            let alert = UIAlertController(title: message, message: "To give permissions tap on 'Change Settings' button", preferredStyle: .alert)
            
            // Add "OK" Button to alert, pressing it will bring you to the settings app
            alert.addAction(UIAlertAction(title: "Change Settings", style: .default, handler: { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }))
            // Show the alert with animation
            alert.show()
        }
    }
    
    static func  requestCameraRollAuthorzationStatus(completionHandler: (() -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                completionHandler!()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success { // if request is granted (success is true)
                    DispatchQueue.main.async {
                        self .requestCameraRollAuthorzationStatus(completionHandler: completionHandler)
                    }
                } else {
                    // if request is denied (success is false)
                    // Create Alert
                    self.openSettings(true)
                }
            }
        case .restricted, .denied:
            self.openSettings(true)
        @unknown default:
            print("unknown")
        }
    }
    
    static func requestPhotoLibraryAuthorzationStatusWithCompletionHandler(completionHandler: (() -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                completionHandler!()
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                self.requestPhotoLibraryAuthorzationStatusWithCompletionHandler(completionHandler: completionHandler)
            }
        case .restricted, .denied:
            self.openSettings(false)
            
        @unknown default:
            self.openSettings(false)
        }
    }
    
    static func requestVideoRecordAuthorzationStatusWithCompletionHandler(completionHandler: (() -> Void)?) {
        requestCameraRollAuthorzationStatus {
            DispatchQueue.main.async {
                completionHandler!()
            }
        }
    }
    
    static func requestMicrophoneAuthorzationStatusWithCompletionHandler(completionHandler: (() -> Void)?) {
        let recordPermission = AVAudioSession.sharedInstance().recordPermission
        switch recordPermission {
        case .granted:
            DispatchQueue.main.async {
                completionHandler!()
            }
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { success in
                self.requestMicrophoneAuthorzationStatusWithCompletionHandler(completionHandler: completionHandler)
            }
        case .denied:
            self.openMicrophoneSettings()
        @unknown default:
            self.openMicrophoneSettings()
        }
    }
    
    static func openMicrophoneSettings() {
        let message: String = Bundle.main.object(forInfoDictionaryKey: "NSMicrophoneUsageDescription") as! String
        
        let alert = UIAlertController(title: message, message: "To give permissions tap on 'Change Settings' button", preferredStyle: .alert)
        
        // Add "OK" Button to alert, pressing it will bring you to the settings app
        alert.addAction(UIAlertAction(title: "Change Settings", style: .default, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }))
        // Show the alert with animation
        alert.show()
    }
}


