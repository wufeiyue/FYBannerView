//
//  FYControlStyle.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

public struct FYControlStyle{
    
    public var position:FYPosition = (x:.default(), y:.default())
    public var borderWidth:CGFloat = 2
    public var borderColor:UIColor = UIColor.clear
    public var normalColor:UIColor = UIColor.white.withAlphaComponent(0.6)
    public var selectorColor:UIColor = UIColor.white
    public var cornerRadius:CGFloat = 3.5
    public var width:CGFloat = 7
    public var height:CGFloat = 7
    public var margin:CGFloat = 9
    
    /// 根据提供的size和control元素的个数，转换成control的point
    ///
    /// - Parameters:
    ///   - size: 一般是control父视图的size
    ///   - num: control元素的个数
    /// - Returns: control的rect
    public func convertPoint(from size:CGSize, num:Int) -> CGPoint{
        
        let size = calcDotSize(num: num)
        
        let x = position.x.calc(element: size.width, parent: size.width)
        let y = position.y.calc(element: size.height, parent: size.height)
        
        return CGPoint(x:x, y:y)
    }
    
    public func convertPoint(element eSize:CGSize, parent pSize:CGSize, num:Int) -> CGPoint{
        
        let x = position.x.calc(element: eSize.width, parent: pSize.width)
        let y = position.y.calc(element: eSize.height, parent: pSize.height)
        
        return CGPoint(x:x, y:y)
    }
    
    /// 获取control元素的位置
    ///
    /// - Parameter index: control元素的索引 (index从0开始)
    /// - Returns: control元素的位置
    public func calcDotPosition(index:Int) -> CGPoint {
        
        let x = (width + margin) * CGFloat(index)
        return CGPoint(x:x ,y:0)
    }
    
    /// 获取control的尺寸
    ///
    /// - Parameter num: control元素的个数 (num从0开始)
    /// - Returns: size
    func calcDotSize(num:Int) -> CGSize {
        
        var size = CGSize.zero
        if num > 0 {
            size.width = width * CGFloat(num) + margin * CGFloat(num - 1)
        }
        size.height = height
        return size
    }
}
