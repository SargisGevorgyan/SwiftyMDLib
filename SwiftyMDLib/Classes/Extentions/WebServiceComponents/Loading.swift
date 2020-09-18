//
//  Loading.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import Foundation
import Lottie
import UIKit

open class Loading {
    public static var animation: Animation?
    public static var animationSize: CGSize = .init(width: 100.scaled, height: 100.scaled)
    public static var font = UIFont.systemFont(ofSize: 14)
    public static var fontColor = UIColor.white
    public static var loaderText = "Please wait..."
    public static var container = UIView()
    public static var bgColor:UIColor = UIColor(displayP3Red: 34/255, green: 34/255, blue: 34/255, alpha: 0.8)
    static var canShowLoader = true
    private static var loadingView : UIView!
    private static var activityIndicator = UIActivityIndicatorView()
    private static var imageIndicator = UIView()
    private static var animationView: AnimationView? = AnimationView()
    private static var loadingText: UILabel?
    
    
    open class func showLoading(_ view: UIView, _ indicatorColor: UIColor, _ backColor: UIColor = bgColor, text: String? = loaderText) {
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
        loadingView.tag = 666
        loadingView.backgroundColor = backColor
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        container.backgroundColor = backColor
        container.clipsToBounds = true
        loadingView.addSubview(container)
        
        activityIndicator = UIActivityIndicatorView.init(style: .white)
        if let animation = animation {
            animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            animationView?.loopMode = .loop
            animationView?.animation = animation
            container.addSubview(animationView!)
            animationView?.mdLayout.setWidth(type: .equal(constant: animationSize.width))
            animationView?.mdLayout.setHeight(type: .equal(constant: animationSize.height))
            animationView?.mdLayout.setCenterX(anchor: container.centerXAnchor, type: .equal(constant: 0))
            animationView?.mdLayout.setCenterY(anchor: container.centerYAnchor, type: .equal(constant: 0))
            animationView?.play()
            if let text = text {
                addLabelUnder(animationView!, withTextt: text)
            }
        } else {
            activityIndicator.color = indicatorColor
            activityIndicator.startAnimating()
            activityIndicator.center = container.center
            if let text = text {
                activityIndicator.clipsToBounds = false
                addLabelUnder(activityIndicator, withTextt: text)
            }
            DispatchQueue.main.async {
                container.addSubview(activityIndicator)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    static func addLabelUnder(_ view:UIView, withTextt text: String) {
        loadingText = UILabel()
        guard  let label = loadingText else {
            return
        }
        label.font = font
        label.text = text
        label.textColor = fontColor
        view.addSubview(label)
        view.clipsToBounds = false
        view.superview?.clipsToBounds = false
        label.mdLayout.setCenterX(anchor: view.centerXAnchor, type: .equal(constant: 0))
        label.mdLayout.setCenterY(anchor: view.centerYAnchor, type: .equal(constant: 60.scaled ))
        
//        label.mdLayout.setTop(anchor: view.bottomAnchor, type: .equal(constant: 15))
        
        
    }
    
    
    open class func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.animationView?.stop()
        self.loadingText?.removeFromSuperview()
        self.loadingText = nil
        if self.loadingView != nil {
            self.animationView?.removeFromSuperview()
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        } else {
            if let view = UIApplication.shared.windows[0].subviews.first?.subviews.first(where: {$0.tag == 666}) {
                view.removeFromSuperview()
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    open class func showLoadingOnWindow(_ indicatorColor: UIColor = UIColor.gray, _ backColor: UIColor =  bgColor) {
        var window = UIApplication.shared.keyWindow
        if (window == nil) {
            window = UIApplication.shared.windows.first
        }
        if let baseView = window?.subviews.last {
            Loading.showLoading(baseView, indicatorColor, backColor)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                var window = UIApplication.shared.keyWindow
                if (window == nil) {
                    window = UIApplication.shared.windows.first
                }
                if let baseView = window?.subviews.last {
                    Loading.showLoading(baseView, indicatorColor, backColor)
                }
            }
        }
    }
    
    
    open class func hideLoadingOnWindow() {
        var window = UIApplication.shared.keyWindow
        if (window == nil) {
            window = UIApplication.shared.windows.first
        }
        Loading.hideLoading()
        
    }
    
    open class func showToast(withText: String) {
        var window = UIApplication.shared.keyWindow
        if (window == nil) {
            window = UIApplication.shared.windows.first
        }
        if let baseView = window?.subviews.last {
            baseView.makeToast(withText, duration: 3.0, position: .bottom)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                var window = UIApplication.shared.keyWindow
                if (window == nil) {
                    window = UIApplication.shared.windows.first
                }
                if let baseView = window?.subviews.last {
                    baseView.makeToast(withText, duration: 3.0, position: .bottom)
                }
            }
        }
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

