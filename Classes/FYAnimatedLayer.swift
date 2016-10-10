//
//  FYAnimatedLayer.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/8.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

public class FYAnimatedLayer:CAShapeLayer{
    public let normal_color:CGColor
    public let selected_color:CGColor
    public let border: CGFloat
    public let width:CGFloat
    
    public init(currentColor:UIColor,normalColor:UIColor, border:CGFloat,width:CGFloat) {
        self.normal_color = normalColor.CGColor
        self.selected_color = currentColor.CGColor
        self.border = border
        self.width = width
        
        super.init()
        createView()
    }

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView(){
        
        self.frame.size = CGSize(width: width, height: width)
        self.fillColor = UIColor.clearColor().CGColor
        self.strokeColor = normal_color
        self.lineWidth = border
        self.strokeStart = 0
        self.strokeEnd = 1
    
        let circle = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: width, height: width))
        self.path = circle.CGPath
    }
    
    public func startAnimation(){
        
        let fill_color = CABasicAnimation.init(keyPath: "fillColor")
        fill_color.fromValue = UIColor.clearColor().CGColor
        fill_color.toValue = selected_color
        
        let stroke_color = CABasicAnimation.init(keyPath: "strokeColor")
        stroke_color.fromValue = normal_color
        stroke_color.toValue = UIColor.clearColor().CGColor
        
        let zoomSize = CABasicAnimation(keyPath:"transform")
        zoomSize.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))
        zoomSize.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.4, 1.4, 1))
        
        let zoom = CAAnimationGroup()
        zoom.animations = [fill_color,zoomSize,stroke_color]
        zoom.repeatCount = 1
        zoom.removedOnCompletion = false
        zoom.fillMode = kCAFillModeForwards
        zoom.duration = 0.2
        zoom.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut )
        addAnimation(zoom, forKey: "transform-start")
    }
    
    public func stopAnimation(){
        
        let fill_color = CABasicAnimation.init(keyPath: "fillColor")
        fill_color.fromValue = selected_color
        fill_color.toValue = UIColor.clearColor().CGColor

        let stroke_color = CABasicAnimation.init(keyPath: "strokeColor")
        stroke_color.fromValue = UIColor.clearColor().CGColor
        stroke_color.toValue = normal_color

        
        let zoomSize = CAKeyframeAnimation.init(keyPath: "transform")
        zoomSize.values = [
                       NSValue(CATransform3D: CATransform3DMakeScale(1.4, 1.4, 1)),
                       NSValue(CATransform3D: CATransform3DMakeScale(0.8, 0.8, 1)),
                       NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1))
                      ]
        
        let zoom = CAAnimationGroup()
        zoom.animations = [fill_color,zoomSize,stroke_color]
        zoom.repeatCount = 1
        zoom.removedOnCompletion = false
        zoom.fillMode = kCAFillModeForwards
        zoom.duration = 0.3
        zoom.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut )
        addAnimation(zoom, forKey: "transform-stop")
    }
    
}