//
//  FYSliderViewCustomizable.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/7.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

public protocol FYSliderViewCustomizable:class {
    
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

public extension FYSliderViewCustomizable{
    var placeholderImage:UIImage{
        return fetchTempBackgroundImage()
    }
    var infiniteLoop:Bool{
        return true
    }
    var autoScroll:Bool{
        return true
    }
    var controlType:FYPageControlType{
        
        return .custom(currentColor: UIColor.whiteColor(),
                       normalColor: UIColor(red: 1, green: 1, blue: 1, alpha:0.8),
                       layout: [.point(x:.centerX, y:.bottom(13)), .size(borderWidth: 2, circleWidth: 4)],
                       animationType:.zoom)
        
    }
    var scrollTimeInterval:NSTimeInterval{
        return 4
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
        return [.labelHeight(36)]
    }
    
}

//在没有配置占位图的时候，调用此方法会绘制一个纯色背景的图充当占位图
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
