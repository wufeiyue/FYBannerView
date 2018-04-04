//
//  BannerCustomizable.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import UIKit

public protocol BannerCustomizable: class {
    
    /// 背景图
    var placeholder: UIImage { get }
    
    /// 是否需要无限循环  默认是
    var infiniteLoop: Bool { get }
    
    /// 是否自动滚动  默认是
    var isAutoScroll: Bool { get }
    
    /// 滚动间隔 以秒为单位 默认4秒
    var scrollTimeInterval: TimeInterval { get }
    
    /// 滚动方向   默认水平方向
    var scrollDirection: BannerViewScrollDirection { get }
    
    /// 只有一个元素时是否隐藏 pageControl 默认隐藏
    var isHidesForSinglePage: Bool { get }
    
    /// 控制柄的样式  默认显示自定义
    var controlStyle: BannerPageControlStyle { get }
}

public extension BannerCustomizable {
    
    var placeholder: UIImage {
        return UIImage()
    }
    
    var infiniteLoop: Bool {
        return true
    }
    
    var isAutoScroll: Bool {
        return true
    }
    
    var scrollTimeInterval: TimeInterval {
        return 4.0
    }
    
    var scrollDirection: BannerViewScrollDirection {
        return .horizontal
    }
    
    var isHidesForSinglePage: Bool {
        return true
    }
    
    var controlStyle: BannerPageControlStyle {
        return BannerPageControlStyle()
    }
}
