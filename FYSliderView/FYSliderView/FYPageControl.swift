//
//  FYPageControl.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/7.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class FYPageControl: UIControl {

    
    var numberOfPages:Int?
    var currentPage:Int?{
        willSet{
            if let value = newValue {
                guard value < numberOfPages else{
                    fatalError("当前的页数已经超过总页数，会造成数组越界")
                }
                self.changeActivity(true, index: value)
            }
        }
        
        didSet{
            if let value = oldValue {
                self.changeActivity(false, index: value)
            }
        }
    }

    var margin:CGFloat!
    var dotWidth:CGFloat!
    var borderWidth:CGFloat!
    
    let hidesForSinglePage:Bool
    let pageIndicatorTintColor: UIColor
    let currentPageIndicatorTintColor: UIColor
    private var dots:[FYAnimatedLayer] = [FYAnimatedLayer]()
    
    init(pageIndicatorTintColor:UIColor, currentPageIndicatorTintColor:UIColor, hidesForSinglePage:Bool) {
        
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.hidesForSinglePage = hidesForSinglePage
        
        super.init(frame: CGRect.zero)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDots(){
        
        for i in 0..<numberOfPages! {
            
            let dot:FYAnimatedLayer!
            
            if i < dots.count {
                dot = dots[i]
            }else{
                dot = generateDotView()
            }

            updateDotFrame({ (point) in
                
                dot.position = point
                
                }, index: CGFloat(i))
        }
        changeActivity(true, index: 0) //默认第一个显示
        hideForSinglePage()
    }
    
    private func updateDotFrame(closure:(CGPoint) -> Void, index:CGFloat){
        let x = (dotWidth + margin) * index + dotWidth / 2
        let y = bounds.size.height / 2
        let point = CGPoint(x:x ,y:y)
        closure(point)
    }
    
    //只有一个就隐藏pageControl
    private func hideForSinglePage(){
        if dots.count == 1 && hidesForSinglePage == true {
            hidden = true
        }else{
            hidden = false
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
        
        let dotLayer = FYAnimatedLayer.init(currentColor: currentPageIndicatorTintColor, normalColor: pageIndicatorTintColor, border: borderWidth, width: dotWidth - borderWidth)
        
        layer.addSublayer(dotLayer)
        dots.append(dotLayer)
        
        return dotLayer
    }
    
    private func changeActivity(active:Bool, index:Int){
        
        let dot = dots[index]
        
        if active {
            dot.startAnimation()
        }else{
            dot.stopAnimation()
        }
    }
    
    func sizeForNumberOfPages(pageCount: Int) -> CGSize {
        return CGSize(width: (dotWidth + margin) * CGFloat(pageCount) - margin , height:dotWidth)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bounds.origin = CGPoint.zero
        bounds.size = sizeForNumberOfPages(numberOfPages ?? 0)
        
        updateDots()
    }
    


}
