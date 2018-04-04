
//
//  BannerViewDelegate.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

public protocol BannerViewDelegate: class {
    
    /// 点击图片的回调
    ///
    /// - Parameter index: 当前索引
    func bannerView(_ view: FYBannerView, at index:Int)
    
    /// 图片滚动的回调
    ///
    /// - Parameter index: 当前索引
    func bannerView(_ view: FYBannerView, to index:Int)
}
