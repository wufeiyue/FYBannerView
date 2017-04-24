//
//  FYBannerCustomizable.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

public typealias ScrollDirection = UICollectionViewScrollDirection

public protocol FYBannerCustomizable:NSObjectProtocol {

    //默认背景图
    var placeholderImage:UIImage {get}
    
    //是否需要无限循环
    var infiniteLoop:Bool {get}
    
    //是否自动滚动
    var autoScroll:Bool {get}
    
    //默认滚动间隔时间
    var scrollTimeInterval:TimeInterval {get}
    
    //滚动方向
    var scrollDirection:ScrollDirection {get}
    
    //图片的填充方式
    var imageContentMode:UIViewContentMode {get}
    
    //只有一个元素时就隐藏pageControl
    var hidesForSinglePage:Bool {get}

    var controlStyle:FYControlStyle { get }
    
}

extension FYBannerCustomizable {
    var placeholderImage:UIImage{
        return UIImage()
    }
    
    var infiniteLoop:Bool{
        return true
    }
    
    var autoScroll:Bool {
        return true
    }
    
    var scrollTimeInterval:TimeInterval {
        return 3.0
    }
    
    var scrollDirection:ScrollDirection {
        return .horizontal
    }
    
    var imageContentMode:UIViewContentMode {
        return .scaleAspectFill
    }
    
    var hidesForSinglePage:Bool {
        return true
    }
    
    var controlStyle:FYControlStyle {
        return FYControlStyle()
    }
    
    
}


protocol FYBannerViewDelegate:NSObjectProtocol {
    
    /// 点击图片的回调
    ///
    /// - Parameter index: 当前索引
    func bannerView(at index:Int)
    
    /// 图片滚动的回调
    ///
    /// - Parameter index: 当前索引
    func bannerView(to index:Int)
}
