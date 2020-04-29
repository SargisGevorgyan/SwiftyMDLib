//
//  CountDownLabel.swift
//
//  Copyright © 2020 MagicDevs. All rights reserved.
//

import UIKit

public class CountDownLabel: UILabel {
    private static let countDownLastTime = "CountDownLastTime"
    let countdown = CountDown()
    
    var btnSendAgain:UIButton?
    var seconds = 120
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        countdown.delegate = self
        
    }
    
    fileprivate  func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    fileprivate  func removeObservers() {
        UserDefaults.standard.set(0, forKey: CountDownLabel.countDownLastTime)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        
        let lastTime = UserDefaults.standard.integer(forKey: CountDownLabel.countDownLastTime)
        if lastTime > 0 {
            let lastDate = Date(timeIntervalSince1970: TimeInterval(lastTime))
            let distance:Int = Int(fabs(lastDate.timeIntervalSince(Date())))
            
            if distance < countdown.count {
                countdown.startFor(seconds:countdown.count - distance)
                btnSendAgain?.alpha = 0.5
            }
        }
    }
    
    @objc fileprivate func applicationDidEnterBackground() {
        
        countdown.stop()
        
        addObservers()
        
        let lastTime = Int(Date().timeIntervalSince1970)
        UserDefaults.standard.set(lastTime, forKey: CountDownLabel.countDownLastTime)
        UserDefaults.standard.synchronize()
    }
    
    public func startCountDown(button: UIButton, sec:Int = 120) {
        seconds = sec
        btnSendAgain = button
        btnSendAgain?.isEnabled = false
        btnSendAgain?.alpha = 0.5
        countdown.startFor(seconds: seconds)
        
        addObservers()
    }
}

extension CountDownLabel: CountDownDelegate {
    public func countDownDidStop() {
        btnSendAgain?.isEnabled = true
        btnSendAgain?.alpha = 1
        removeObservers()
    }
    
    public func countDownDidChange(_ countdown: CountDown, min: String, sec: String) {
        text = "\(min):\(sec)"
    }
    
    
}
