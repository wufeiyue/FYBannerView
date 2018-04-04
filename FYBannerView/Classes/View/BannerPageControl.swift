//
//  TimerDelegate.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//

import Foundation

public class BannerPageControl: UIView {
    
    public var borderColor: UIColor = UIColor.white.withAlphaComponent(0.6)
    public var normalColor: UIColor = UIColor.white.withAlphaComponent(0.6)
    public var selectorColor: UIColor = UIColor.white
    
    public var isHidesForSinglePage: Bool = true

    /** pageControl的样式*/
    internal var style: BannerPageControlStyle!
    
    internal var numberOfPages: Int = 0 {
        didSet {
            updateLayer()
            invalidateIntrinsicContentSize()
            
            if defaultActiveStatus {
                defaultActiveStatus = false
                //默认第一个显示
                changeActivity(index: 0, isActive: true)
            }
        }
    }
    
    internal var currentPage:Int = 0 {
        willSet{
            if newValue == currentPage { return }
            changeActivity(index: newValue, isActive: true)
        }
        
        didSet{
            if currentPage == oldValue { return }
            changeActivity(index: oldValue, isActive: false)
        }
    }
    
    private var defaultActiveStatus: Bool = true
    private var dots:[DotLayer] = [] {
        
        didSet{
            
            if dots.count == 1 {
                
                if isHidesForSinglePage {
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
    
    private func changeActivity(index: Int, isActive: Bool){
        
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
    
    private func createLayer() -> DotLayer {
        
        var dot: DotLayer!
        
        switch style.type {
        case .ring:
            let ringDot = RingDotLayer(size: CGSize(width: style.width, height: style.height), borderWidth: style.borderWidth)
            ringDot.normalColor = normalColor.cgColor
            ringDot.selectedColor = selectorColor.cgColor
            dot = ringDot
        }
        
        defer {
            dots.append(dot)
        }
        
        dot.anchorPoint = CGPoint.zero
        dot.stopAnimation()
        return dot
    }
    
    public override var intrinsicContentSize: CGSize {
        return style.calcDotSize(num: numberOfPages)
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
            var dot: CALayer!
            if dots.count > i {
                dot = dots[i]
            }
            else{
                dot = createLayer()
            }
            
            let point = style.calcDotPosition(index: i)
            
            dot.position = point
            
            layer.addSublayer(dot)
        }
    }
}

