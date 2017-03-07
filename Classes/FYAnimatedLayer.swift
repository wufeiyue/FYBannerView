//
//  FYAnimatedLayer.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

private protocol FYAnimationType{
    var normalColor:CGColor {get}
    var selectedColor:CGColor {get}
    
    func zoom(isPlaying:Bool) -> Void
    func transition(isPlaying:Bool) -> Void
    
}

extension FYAnimationType where Self:CAShapeLayer{
    ///缩放动画
    func zoom(isPlaying:Bool) -> Void{
        if isPlaying {
            let fill_color = CABasicAnimation.init(keyPath: "fillColor")
            fill_color.fromValue = UIColor.clear.cgColor
            fill_color.toValue = selectedColor
            
            let stroke_color = CABasicAnimation.init(keyPath: "strokeColor")
            stroke_color.fromValue = normalColor
            stroke_color.toValue = UIColor.clear.cgColor
            
            let zoomSize = CABasicAnimation(keyPath:"transform")
            zoomSize.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
            zoomSize.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.4, 1.4, 1))
            
            let zoom = CAAnimationGroup()
            zoom.animations = [fill_color]
            zoom.repeatCount = 1
            zoom.isRemovedOnCompletion = false
            zoom.fillMode = kCAFillModeForwards
            zoom.duration = 0.2
            zoom.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut )
            add(zoom, forKey: "transform-start")
        }else{
            let fill_color = CABasicAnimation.init(keyPath: "fillColor")
            fill_color.fromValue = selectedColor
            fill_color.toValue = UIColor.clear.cgColor
            
            let stroke_color = CABasicAnimation.init(keyPath: "strokeColor")
            stroke_color.fromValue = UIColor.clear.cgColor
            stroke_color.toValue = normalColor
            
            
            let zoomSize = CAKeyframeAnimation.init(keyPath: "transform")
            zoomSize.values = [
                NSValue(caTransform3D: CATransform3DMakeScale(1.4, 1.4, 1)),
                NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1)),
                NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1))
            ]
            
            let zoom = CAAnimationGroup()
            zoom.animations = [fill_color,zoomSize,stroke_color]
            zoom.repeatCount = 1
            zoom.isRemovedOnCompletion = false
            zoom.fillMode = kCAFillModeForwards
            zoom.duration = 0.3
            zoom.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut )
            add(zoom, forKey: "transform-stop")
            
        }
    }
    
    ///过渡动画(有渐变效果)
    func transition(isPlaying:Bool) -> Void {
        if isPlaying {
            let color = CABasicAnimation.init(keyPath: "fillColor")
            color.fromValue = normalColor
            color.toValue = selectedColor
            color.isRemovedOnCompletion = false
            color.fillMode = kCAFillModeForwards
            add(color, forKey: "color-start")
        }else{
            let color = CABasicAnimation.init(keyPath: "fillColor")
            color.fromValue = selectedColor
            color.toValue = normalColor
            color.isRemovedOnCompletion = false
            color.fillMode = kCAFillModeForwards
            add(color, forKey: "color-stop")
        }
    }
    
}

public class FYAnimatedLayer:CAShapeLayer, FYAnimationType{
    public let normal_color:CGColor
    public let selected_color:CGColor
    public let border: CGFloat
    public let layerWidth:CGFloat
    public var animationType:FYPageControlAnimationType!
    var normalColor:CGColor{
        return normal_color
    }
    
    var selectedColor:CGColor{
        return selected_color
    }
    
    public init(currentColor:UIColor,normalColor:UIColor, border:CGFloat,width:CGFloat) {
        self.normal_color = normalColor.cgColor
        self.selected_color = currentColor.cgColor
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
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = normal_color
        self.lineWidth = border
        self.strokeStart = 0
        self.strokeEnd = 1
        let circle = UIBezierPath(ovalIn: CGRect(x: border/2, y: border/2, width: layerWidth + border, height: layerWidth + border))
        self.path = circle.cgPath
    }
    
    public func startAnimation(){
        guard let type = animationType else{return}
        switch type {
        case .zoom:
            zoom(isPlaying: true)
        case .transition:
            transition(isPlaying: true)
        }
    }
    
    public func stopAnimation(){
        guard let type = animationType else{return}
        switch type {
        case .zoom:
            zoom(isPlaying: false)
        case .transition:
            transition(isPlaying: false)
            break
        }
    }
    
}
