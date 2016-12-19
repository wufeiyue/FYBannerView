//
//  FYAnimatedLayer.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/8.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

private protocol FYAnimationType{
    var normalColor:CGColor {get}
    var selectedColor:CGColor {get}
    
    func zoom(isPlaying:Bool) -> Void
    func transition(isPlaying:Bool) -> Void
    func countdown(isPlaying:Bool, duration:NSTimeInterval) -> Void
}

extension FYAnimationType where Self:CAShapeLayer{
    ///缩放动画
    func zoom(isPlaying:Bool) -> Void{
        if isPlaying {
            let fill_color = CABasicAnimation.init(keyPath: "fillColor")
            fill_color.fromValue = UIColor.clearColor().CGColor
            fill_color.toValue = selectedColor
            
            let stroke_color = CABasicAnimation.init(keyPath: "strokeColor")
            stroke_color.fromValue = normalColor
            stroke_color.toValue = UIColor.clearColor().CGColor
            
            let zoomSize = CABasicAnimation(keyPath:"transform")
            zoomSize.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1))
            zoomSize.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.4, 1.4, 1))
            
            let zoom = CAAnimationGroup()
            zoom.animations = [fill_color]
            zoom.repeatCount = 1
            zoom.removedOnCompletion = false
            zoom.fillMode = kCAFillModeForwards
            zoom.duration = 0.2
            zoom.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut )
            addAnimation(zoom, forKey: "transform-start")
        }else{
            let fill_color = CABasicAnimation.init(keyPath: "fillColor")
            fill_color.fromValue = selectedColor
            fill_color.toValue = UIColor.clearColor().CGColor
            
            let stroke_color = CABasicAnimation.init(keyPath: "strokeColor")
            stroke_color.fromValue = UIColor.clearColor().CGColor
            stroke_color.toValue = normalColor
            
            
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
    
    ///过渡动画(有渐变效果)
    func transition(isPlaying:Bool) -> Void {
        if isPlaying {
            let color = CABasicAnimation.init(keyPath: "fillColor")
            color.fromValue = normalColor
            color.toValue = selectedColor
            color.removedOnCompletion = false
            color.fillMode = kCAFillModeForwards
            addAnimation(color, forKey: "color-start")
        }else{
            let color = CABasicAnimation.init(keyPath: "fillColor")
            color.fromValue = selectedColor
            color.toValue = normalColor
            color.removedOnCompletion = false
            color.fillMode = kCAFillModeForwards
            addAnimation(color, forKey: "color-stop")
        }
    }
    //倒计时
    func countdown(isPlaying:Bool, duration:NSTimeInterval) -> Void{
        if isPlaying {
            let stroke = CABasicAnimation.init(keyPath: "strokeEnd")
            stroke.fromValue = 0
            stroke.toValue = 1
            stroke.duration = duration
            stroke.repeatCount = 1
            addAnimation(stroke, forKey: "stroke-start")
        }else{
            removeAnimationForKey("stroke-start")
        }
    }
}

public class FYAnimatedLayer:CAShapeLayer, FYAnimationType{
    public let normal_color:CGColor
    public let selected_color:CGColor
    public let border: CGFloat
    public let layerWidth:CGFloat
    public var animationType:FYPageControlAnimationType!
    public var animationDuration:NSTimeInterval!
    var normalColor:CGColor{
        return normal_color
    }
    
    var selectedColor:CGColor{
        return selected_color
    }
    
    public init(currentColor:UIColor,normalColor:UIColor, border:CGFloat,width:CGFloat) {
        self.normal_color = normalColor.CGColor
        self.selected_color = currentColor.CGColor
        self.border = border
        self.layerWidth = width
        
        super.init()
        createView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView(){
        self.bounds.size = CGSize(width: layerWidth + border * 2, height: layerWidth + border * 2)
        self.fillColor = UIColor.clearColor().CGColor
        self.strokeColor = normal_color
        self.lineWidth = border
        self.strokeStart = 0
        self.strokeEnd = 1
        let circle = UIBezierPath(ovalInRect: CGRect(x: border/2, y: border/2, width: layerWidth + border, height: layerWidth + border))
        self.path = circle.CGPath
    }
    
    public func startAnimation(){
        guard let type = animationType else{return}
        switch type {
        case .zoom:
            zoom(true)
        case .transition:
            transition(true)
        case .countdown:
            countdown(true,duration: animationDuration)
        }
    }
    
    public func stopAnimation(){
        guard let type = animationType else{return}
        switch type {
        case .zoom:
            zoom(false)
        case .transition:
            transition(false)
        case .countdown:
            countdown(false,duration: animationDuration)
            break
        }
    }
    
}
