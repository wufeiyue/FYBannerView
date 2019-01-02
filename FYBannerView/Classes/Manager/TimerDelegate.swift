//
//  TimerDelegate.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

@objc protocol TimerDelegate: class {
    var timer: Timer? { set get }
    @objc func timerElamsed()
}

extension TimerDelegate {
    
    public func setupTimer(timeInterval: TimeInterval) {
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerElamsed), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
            self.timer = timer
        }
    }
    
    /// 停止定时器
    public func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension FYBannerView: TimerDelegate { }
