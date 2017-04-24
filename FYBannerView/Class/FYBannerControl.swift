//
//  FYBannerControl.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

enum LayerType {
    case `default`
    case ring //圆环
}

protocol FYDotLayerDelegate {
    var normalColor:CGColor { get }
    var selectorColor:CGColor { get }
    var type:LayerType { get }
    func startAnimation()
    func stopAnimation()
}
extension FYDotLayerDelegate where Self:CALayer{
    func animationStartForRing(){
        borderColor = selectorColor
    }
    
    func animationStopForRing(){
        borderColor = normalColor
    }
    
    
    func animationStartForDefault(){
        backgroundColor = selectorColor
    }
    
    func animationStopForDefault(){
        backgroundColor = normalColor
    }
}

class FYDotLayer:CALayer,FYDotLayerDelegate {
    
    var normalColor: CGColor = UIColor.white.withAlphaComponent(0.8).cgColor
    var selectorColor: CGColor = UIColor.white.cgColor
    var type:LayerType = .default
    
    func startAnimation() {
        switch type {
        case .default:
            animationStartForDefault()
        case .ring:
            animationStartForRing()
        }
    }
    
    func stopAnimation(){
        switch type {
        case .default:
            animationStopForDefault()
        case .ring:
            animationStopForRing()
        }
    }
}

open class FYBannerControl: UIView {
    
    /** 父视图的size*/
    open var parentSize:CGSize = CGSize.zero
    
    /** pageControl的样式*/
    open var controlStyle:FYControlStyle!
    
    open var hidesForSinglePage:Bool = true
    
    // default is 0
    open var numberOfPages:Int = 0 {
        didSet {
            updateLayer()
        }
    }
    
    // default is 0. value pinned to 0..numberOfPages-1
    open var currentPage:Int = 0 {
        willSet{
            if newValue == currentPage { return }
            changeActivity(index: newValue, isActive: true)
        }
        
        didSet{
            if currentPage == oldValue { return }
            changeActivity(index: oldValue, isActive: false)
        }
    }
    
    private var dots:[FYDotLayer] = [] {
        
        didSet{
            if dots.count == 1 {
        
                if hidesForSinglePage {
                    dots.first?.isHidden = true
                }
                else{
                    changeActivity(index: 0, isActive: true)
                }
            }
            else{
                dots.first?.isHidden = false
            }
        }
    }
    
    private func updateLayer(){
        let sub = dots.count - numberOfPages
        
        if sub > 0 {
            removeLayer(num: sub)
        }
        else if sub < 0 {
            addLayer()
        }
    }
    
    private func addLayer(){
        for i in 0 ..< numberOfPages {
            var dot:FYDotLayer!
            if dots.count > i {
                dot = dots[i]
            }
            else{
                dot = createLayer()
            }
            
            let point = controlStyle.calcDotPosition(index: i)
            
            dot.position = point
            
            layer.addSublayer(dot)
        }
    }
    
    /// 移除多余layer
    ///
    /// - Parameter num: 需要移除的layer个数
    private func removeLayer(num:Int){
        if let unwrapped = layer.sublayers, unwrapped.count >= num {
            for _ in 0 ..< num {
                layer.sublayers?.last?.removeFromSuperlayer()
            }
        }
        
        let range:Range<Int> = numberOfPages ..< dots.count
        dots.removeSubrange(range)
        
    }
    
    private func createLayer() -> FYDotLayer{
        let dot = FYDotLayer()
        
        defer {
            dots.append(dot)
        }
        //初始化配置dot属性，不在这里设置position
        dot.borderColor = controlStyle.borderColor.cgColor
        dot.borderWidth = controlStyle.borderWidth
        dot.bounds.size = CGSize(width:controlStyle.width, height:controlStyle.height)
        dot.normalColor = controlStyle.normalColor.cgColor
        dot.selectorColor = controlStyle.selectorColor.cgColor
        dot.anchorPoint = CGPoint.zero
        dot.cornerRadius = controlStyle.cornerRadius
        dot.stopAnimation()
        return dot
    }
    
    private func changeActivity(index:Int,isActive:Bool){
        guard index >= 0 && index < dots.count else {
            return
        }
        
        if isActive == true {
            dots[index].startAnimation()
        }
        else{
            dots[index].stopAnimation()
        }
        
    }
   
    override open func layoutSubviews() {
        super.layoutSubviews()
        frame.size = controlStyle.calcDotSize(num: numberOfPages)
        frame.origin = controlStyle.convertPoint(element: frame.size, parent: parentSize, num: numberOfPages)
    }
}

