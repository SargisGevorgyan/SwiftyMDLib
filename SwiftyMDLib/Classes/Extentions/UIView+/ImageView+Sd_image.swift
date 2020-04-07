//
//  ImageView+ Sd_image.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
import SDWebImage

public extension UIImage {
    func storeInCache(url: String, completion: (()->())? = nil) {
        SDWebImageManager.shared.imageCache.store(self, imageData: jpegData(compressionQuality: 1), forKey: url, cacheType: .all, completion: completion)
    }
    
    func removeFromCache(url: String, completion: (()->())? = nil) {
        SDWebImageManager.shared.imageCache.removeImage(forKey: url, cacheType: .all, completion: completion)
    }
}

public extension UIImageView {
    func setImage(_ imagePath: String?,_ imgDefault: UIImage = UIImage(), completion: ((UIImage?)->Void)?) {
        if let profileImg = imagePath, (imagePath != "") {
//            self.sd_setIndicatorStyle(UIActivityIndicatorView.Style.gray)
//            self.sd_setShowActivityIndicatorView(true)
            self.sd_setImage(with: URL(string: profileImg), completed: { (image, error, cache, url) in
                if error == nil {
//                    self.sd_removeActivityIndicator()
                     self.image = image
                    completion?(image)
                } else {
                    self.image = imgDefault
                }
            })
        } else {
            self.image = imgDefault
        }
    }
    
}

public extension UIButton {
    func setImage(_ imagePath: String?, _ controllState: UIControl.State = .normal  ,_ imgDefault: UIImage = UIImage(), completion: ((UIImage?)->Void)?) {
        let imageView = UIImageView()
        setImage(imgDefault, for: controllState)
        imageView.setImage(imagePath) { (image) in
            self.setImage(image, for: controllState)
        }
    }
}
