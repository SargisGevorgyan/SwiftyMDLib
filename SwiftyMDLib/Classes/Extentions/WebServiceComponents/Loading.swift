//
//  Loading.swift
//  LatinCamp
//
//  Created by Davit Ghushchyan on 7/9/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation
import Lottie
import UIKit

open class Loading {
    static var canShowLoader = true
    private static var loadingView : UIView!
    private static var container = UIView()
    private static var activityIndicator = UIActivityIndicatorView()
    private static var imageIndicator = UIView()
    private static var animationView: AnimationView? = AnimationView()
    
    
    open class func showLoading(_ view: UIView, _ indicatorColor: UIColor, _ backColor: UIColor = .clear) {
        if !canShowLoader {
            return
        }
        view.layoutIfNeeded()
        if loadingView != nil {
            if loadingView.superview == view {
                return
            }
        }
        loadingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height))
        loadingView.backgroundColor = backColor
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        //        loadingView.center = view.center
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: loadingView.frame.width, height: loadingView.frame.height))
        container.backgroundColor = backColor
        container.clipsToBounds = true
        loadingView.addSubview(container)
        //        container.center = loadingView.center
        
        activityIndicator = UIActivityIndicatorView.init(style: .white)
        
        activityIndicator.color = indicatorColor
        activityIndicator.startAnimating()
        activityIndicator.center = container.center
        DispatchQueue.main.async {
            container.addSubview(activityIndicator)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    open class func hideLoading() {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        self.activityIndicator.stopAnimating()
        self.animationView?.stop()
        
        if self.loadingView != nil {
            self.loadingView.removeFromSuperview()
            self.loadingView = nil
        }
        //        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    open class func showLoadingOnWindow(_ indicatorColor: UIColor = UIColor.red, _ backColor: UIColor = .clear) {
        var window = UIApplication.shared.keyWindow
        if (window == nil) {
            window = UIApplication.shared.windows[0]
        }
        let baseView = window?.subviews.last
        Loading.showLoading(baseView!, indicatorColor, backColor)
    }
    
    
    open class func hideLoadingOnWindow() {
        var window = UIApplication.shared.keyWindow
        if (window == nil) {
            window = UIApplication.shared.windows[0]
        }
        Loading.hideLoading()
        
    }
    
    open class func showToast(withText: String) {
        var window = UIApplication.shared.keyWindow
        if (window == nil) {
            window = UIApplication.shared.windows[0]
        }
        let baseView = window?.subviews.last
        baseView!.makeToast(withText, duration: 3.0, position: .bottom)
    }
    
    open class func showCustomLoading(_ view: UIView) {
        let loadingViewx = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height))
        loadingViewx.frame = view.frame
        loadingViewx.backgroundColor = .clear
        view.addSubview(loadingViewx)
        view.bringSubviewToFront(loadingViewx)
        container = UIView(frame: CGRect(x: 0, y: 0, width: loadingViewx.frame.width, height: loadingViewx.frame.height))
        container.backgroundColor = .clear
        container.clipsToBounds = true
        loadingViewx.addSubview(container)
        let activityIndicator = UIActivityIndicatorView.init(style: .white)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = loadingViewx.center
        DispatchQueue.main.async {
            loadingViewx.addSubview(activityIndicator)
        }
    }
}
