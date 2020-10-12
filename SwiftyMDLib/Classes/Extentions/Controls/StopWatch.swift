//
//  StopWatch.swift
//
//  Copyright © 2020 MagicDevs. All rights reserved.
//

import Foundation

public protocol StopWatchDelegate: class {
    func stopWatch(_ stopWatch: StopWatch, min: String, sec: String, fra: String)
}

public final class StopWatch {
    private var startTime = TimeInterval()
    private var timer = Timer()
    
    var delegate: StopWatchDelegate?
    
    public func start() {
        
        if (!timer.isValid) {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
        }
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    @objc private func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        delegate?.stopWatch(self, min: strMinutes, sec: strSeconds, fra: strFraction)
    }
    
}

public protocol CountDownDelegate: class {
    func countDownDidChange(_ countdown: CountDown, min: String, sec: String)
    func countDownDidStop()
}


public final class CountDown {
    public var count = 300
    public weak var delegate: CountDownDelegate?
    
    private var timer = Timer()
    
    public init() {}
    
    public func startFor(seconds interval: Int) {
        
        if (!timer.isValid) {
            count = interval
            updateTime()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc private func updateTime() {
        
        
        if(count > 0){
            let minutes = String(count / 60)
            var seconds = String(count % 60)
            switch seconds {
            case "0": seconds = "00"
            case "1": seconds = "01"
            case "2": seconds = "02"
            case "3": seconds = "03"
            case "4": seconds = "04"
            case "5": seconds = "05"
            case "6": seconds = "06"
            case "7": seconds = "07"
            case "8": seconds = "08"
            case "9": seconds = "09"
            default: break
            }
            
            count -= 1
            delegate?.countDownDidChange(self, min: minutes, sec: seconds)
        } else {
            stop()
        }
        
    }
    
    
    public func stop(withDelegate: Bool = true) {
        timer.invalidate()
        if withDelegate {
            delegate?.countDownDidChange(self, min: "0", sec: "00")
            delegate?.countDownDidStop()
        }
    }
    
}
