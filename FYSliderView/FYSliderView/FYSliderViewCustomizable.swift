//
//  FYSliderViewCustomizable.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/7.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

protocol FYSliderViewCustomizable {
    
    //默认背景图
    var placeholderImage:UIImage {get}
    
    //是否需要无限循环
    var infiniteLoop:Bool {get}
    
    //是否自动滚动
    var autoScroll:Bool {get}
    
    //默认滚动间隔时间
    var scrollTimeInterval:NSTimeInterval {get}
    
    //滚动方向
    var scrollDirection:UICollectionViewScrollDirection {get}
    
    //图片的填充方式
    var imageContentMode:UIViewContentMode {get}
    
    //分页控件的类型
    var controlType:FYPageControlType {get}
    
    //只有一个元素时就隐藏pageControl
    var hidesForSinglePage:Bool {get}
    
    //文字背景遮罩样式
    var maskType:FYSliderCellMaskType {get}
    
    //文字样式
    var titleStyle:FYTitleStyle {get}
    
}

extension FYSliderViewCustomizable{
    var placeholderImage:UIImage{
        return UIImage(named: "fy_placeholderImage") ?? fetchTempBackgroundImage()
    }
    var infiniteLoop:Bool{
        return true
    }
    var autoScroll:Bool{
        return true
    }
    var controlType:FYPageControlType{
        
        return .custom(currentColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                        normalColor:UIColor(red: 1, green: 1, blue: 1, alpha: 0.8),
                        layout:[.point(x:.centerX, y:.bottom(16)),
                                .size(borderWidth:2,circleWidth:10),
                                .margin(12)
                                ])
        
    }
    var scrollTimeInterval:NSTimeInterval{
        return 2
    }
    var scrollDirection:UICollectionViewScrollDirection{
        return .Horizontal
    }
    var imageContentMode:UIViewContentMode{
        return .ScaleAspectFill
    }
    
    var hidesForSinglePage:Bool{
        return true
    }
    
    var maskType:FYSliderCellMaskType{
        return .gradient(backgroundColors: [UIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                            UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)],
                         offsetY: 100)
    }
    
    var titleStyle:FYTitleStyle{
        return [.fontSize(16)]
    }

}
//MARK: - pageControl相关设置
enum FYPotionsX {
    case left(_:CGFloat)      //居左距离
    case right(_:CGFloat)     //居右距离
    case centerX              //水平居中
}

enum FYPotionsY {
    case top(_:CGFloat)       //居顶距离
    case bottom(_:CGFloat)    //居底距离
    case centerY              //垂直居中
}

enum FYPageControlStyle {
    
    //坐标点
    case point(x:FYPotionsX, y:FYPotionsY)
    //尺寸大小
    case size(borderWidth:CGFloat,circleWidth:CGFloat)
    //元素之间的距离
    case margin(_:CGFloat)
}

enum FYPageControlType {
    
    /* 自定义的pageControl样式，有动画效果
     * currentColor : 当前选中的元素背景色
     * normalColor : 其它默认不被选中元素的背景色
     * layout : 布局样式，根据需要可组合传入pageControl显示的位置/元素的大小/元素之间的距离等
     */
    case custom(currentColor:UIColor , normalColor:UIColor,layout:FYLayout)
    
    /* 使用系统的pageControl样式，无动画效果
     * currentColor : 当前选中的元素背景色
     * normalColor : 其它默认不被选中元素的背景色
     * point : pageControl显示的位置
     */
    case system(currentColor:UIColor , normalColor:UIColor,point:FYPoint)
    
    //隐藏pageControl
    case none
}

//MARK: - 遮罩背景相关设置
enum FYSliderCellMaskType {
    
    //半透明
    case translucent(backgroundColor:UIColor)
    
    /* 渐变色
     * backgroundColors : 渐变色按照数组元素的顺序显示
     * offsetY : 渐变显示的高度,表示的是从底部到顶部的距离
     */
    case gradient(backgroundColors:[UIColor],offsetY:CGFloat)
}
//MARK: - 文字标题相关设置
enum FYTitleLabelStyle{
    case fontSize(_:CGFloat)          //文字大小
    case textColor(_:UIColor)         //文字颜色
    case textInsets(_:UIEdgeInsets)   //文字内部边距
    case labelHeight(_:CGFloat)       //标题label的高度
}

//在没有配置占位图并且本地也没有找到"fy_placeholderImage@2x.png"图片的时候，调用此方法绘制一个纯色背景的图充当占位图
private func fetchTempBackgroundImage() -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    let context = UIGraphicsGetCurrentContext()
    UIColor.groupTableViewBackgroundColor().set()
    CGContextFillRect(context, rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
