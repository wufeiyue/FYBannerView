//
//  FYPageControlStyle.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/11/11.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

//MARK: - pageControl相关设置
public enum FYPotionsX {
    case left(_:CGFloat)      //居左距离
    case right(_:CGFloat)     //居右距离
    case centerX              //水平居中
}

public enum FYPotionsY {
    case top(_:CGFloat)       //居顶距离
    case bottom(_:CGFloat)    //居底距离
    case centerY              //垂直居中
}

public enum FYPageControlStyle {
    
    //坐标点
    case point(x:FYPotionsX, y:FYPotionsY)
    //尺寸大小
    case size(borderWidth:CGFloat,circleWidth:CGFloat)
    //元素之间的距离
    case margin(_:CGFloat)
}

public enum FYPageControlType {
    
    /* 自定义的pageControl样式，有动画效果
     * currentColor : 当前选中的元素背景色
     * normalColor : 其它默认不被选中元素的背景色
     * layout : 布局样式，根据需要可组合传入pageControl显示的位置/元素的大小/元素之间的距离等
     */
    case custom(currentColor:UIColor , normalColor:UIColor,layout:FYLayout, animationType:FYPageControlAnimationType)
    
    /* 使用系统的pageControl样式，无动画效果
     * currentColor : 当前选中的元素背景色
     * normalColor : 其它默认不被选中元素的背景色
     * point : pageControl显示的位置
     */
    case system(currentColor:UIColor , normalColor:UIColor,point:FYPoint)
    
    //隐藏pageControl
    case none
}

///高级用法

public enum FYPageControlAnimationType {
    case countdown //倒计时
    case zoom //缩放(默认)
    case transition //过渡动画
}

public protocol FYPageControlAnimationLayerDelegate {
    var type:FYPageControlAnimationType {get}
}
