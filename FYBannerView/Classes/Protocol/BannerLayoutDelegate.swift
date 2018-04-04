//
//  BannerLayoutDelegate.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

public protocol BannerLayoutDelegate: AnyObject {
    
    func bannerInsets(at indexPath: IndexPath, data: BannerType, in bannerCollectionView: BannerCollectionView) -> UIEdgeInsets
}

extension BannerLayoutDelegate {
    
    public func bannerInsets(at indexPath: IndexPath, data: BannerType, in bannerCollectionView: BannerCollectionView) -> UIEdgeInsets {
        return .zero
    }
}
