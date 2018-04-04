//
//  BannerDisplayDelegate.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

public protocol BannerDisplayDelegate: AnyObject {
    
    /// 图片的填充方式     默认 .scaleAspectFill
    func imageContentMode(for data: BannerType, at indexPath: IndexPath, in bannerCollectionView: BannerCollectionView) -> UIViewContentMode
    
}

extension BannerDisplayDelegate {
    public func imageContentMode(for data: BannerType, at indexPath: IndexPath, in bannerCollectionView: BannerCollectionView) -> UIViewContentMode {
        return .scaleAspectFill
    }
}
