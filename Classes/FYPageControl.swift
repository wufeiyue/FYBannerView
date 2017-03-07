//
//  FYPageControl.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

public class FYPageControl: UIControl {
    
    public var animationDuration:TimeInterval!
    
    public var showAnimation:Bool!
    
    public var numberOfPages:Int?{
        didSet{
            guard let number = numberOfPages, number != oldValue else{return}
            
            updateDots()
            
            if defaultActiveStatus {
                changeActivity(active: true, index: 0) //默认第一个显示
                defaultActiveStatus = false
            }
            
        }
    }
    public var currentPage:Int?{
        willSet{
            if let value = newValue {
                guard value < numberOfPages! else{
                    fatalError("当前的页数已经超过总页数，会造成数组越界")
                }
                self.changeActivity(active: true, index: value)
            }
        }
        
        didSet{
            if let value = oldValue {
                self.changeActivity(active: false, index: value)
            }
        }
    }
    
    public var margin:CGFloat!
    public var dotWidth:CGFloat!
    public var dotBorderWidth:CGFloat!
    public var animationType:FYPageControlAnimationType!
    
    public let hidesForSinglePage:Bool
    public let pageIndicatorTintColor: UIColor
    public let currentPageIndicatorTintColor: UIColor
    private var dots:[FYAnimatedLayer] = [FYAnimatedLayer]()
    private var defaultActiveStatus:Bool = true
    public init(pageIndicatorTintColor:UIColor, currentPageIndicatorTintColor:UIColor, hidesForSinglePage:Bool) {
        
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.hidesForSinglePage = hidesForSinglePage
        
        super.init(frame: CGRect.zero)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDots(){
        
        for i in 0 ..< numberOfPages! {
            
            let dot:FYAnimatedLayer!
            
            if i < dots.count {
                dot = dots[i]
            }else{
                dot = generateDotView()
            }
            
            dot.position = updateDotPosition(index: CGFloat(i))
        }
        //删除pagecontrol重新布局
        if numberOfPages! < dots.count {
            resetDotViews()
        }
        
        hideForSinglePage()
    }
    
    //更新pageControl元素坐标点
    private func updateDotPosition(index:CGFloat) -> CGPoint{
        let x = (dotWidth + dotBorderWidth * 2 + (margin ?? 10)) * index + dotWidth / 2 + dotBorderWidth
        return CGPoint(x:x ,y:dotWidth/2 + dotBorderWidth)
    }
    
    //只有一个就隐藏pageControl
    private func hideForSinglePage(){
        if dots.count == 1 && hidesForSinglePage == true {
            isHidden = true
        }else{
            isHidden = false
        }
    }
    
    private func resetDotViews(){
        for layer in dots {
            layer.removeFromSuperlayer()
        }
        dots.removeAll()
        updateDots()
    }
    
    private func generateDotView() -> FYAnimatedLayer {
        
        let dotLayer = FYAnimatedLayer(currentColor: currentPageIndicatorTintColor,
                                       normalColor: pageIndicatorTintColor,
                                       border: dotBorderWidth,
                                       width: dotWidth)
        dotLayer.animationType = animationType
        layer.addSublayer(dotLayer)
        
        dotLayer.stopAnimation()
        dots.append(dotLayer)
        
        return dotLayer
    }
    
    private func changeActivity(active:Bool, index:Int){
        guard index >= 0 && index < dots.count else{return}
        
        let dot = dots[index]
        
        if active {
            dot.startAnimation()
        }else{
            dot.stopAnimation()
        }
    }
    
    
    public func sizeForNumberOfPages(pageCount: Int) -> CGSize {
        let margin = self.margin ?? 10
        let width = (dotWidth + margin + dotBorderWidth * 2) * CGFloat(pageCount) - margin
        let height = dotWidth + dotBorderWidth * 2
        return CGSize(width: width, height: height)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        bounds.origin = CGPoint.zero
        bounds.size = sizeForNumberOfPages(pageCount: numberOfPages ?? 0)
    }
    
}
