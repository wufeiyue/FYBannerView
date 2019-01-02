//
//  RingDotLayer.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2018/4/4.
//

import UIKit

//圆环Layer
public class RingDotLayer: DotLayer {
    
    public var normalColor: CGColor?
    
    public var selectedColor: CGColor?
    
    public init(size: CGSize, borderWidth: CGFloat) {
        super.init()
        bounds.size = size
        fillColor = UIColor.clear.cgColor
        strokeColor = normalColor
        lineWidth = borderWidth
        strokeStart = 0
        strokeEnd = 1
        let rect = CGRect(origin: .zero, size: size)
        let circle = UIBezierPath(ovalIn: rect)
        path = circle.cgPath
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func startAnimation() {
        
        let fill_color = CABasicAnimation(keyPath: "fillColor")
        fill_color.fromValue = UIColor.clear.cgColor
        fill_color.toValue = selectedColor
        
        let zoom = CAAnimationGroup()
        zoom.animations = [fill_color]
        zoom.repeatCount = 1
        zoom.isRemovedOnCompletion = false
        zoom.fillMode = .forwards
        zoom.duration = 0.2
        zoom.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        add(zoom, forKey: "transform-start")
        
    }
    
    override func stopAnimation() {
        
        let fill_color = CABasicAnimation(keyPath: "fillColor")
        fill_color.fromValue = selectedColor
        fill_color.toValue = UIColor.clear.cgColor
        
        let stroke_color = CABasicAnimation(keyPath: "strokeColor")
        stroke_color.fromValue = UIColor.clear.cgColor
        stroke_color.toValue = normalColor
        
        let zoom = CAAnimationGroup()
        zoom.animations = [fill_color,stroke_color]
        zoom.repeatCount = 1
        zoom.isRemovedOnCompletion = false
        zoom.fillMode = .forwards
        zoom.duration = 0.3
        zoom.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        add(zoom, forKey: "transform-stop")
        
    }
}
