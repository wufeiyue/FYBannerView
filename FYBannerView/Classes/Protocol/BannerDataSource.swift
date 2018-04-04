//
//  BannerDataSource.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

public protocol BannerDataSource: AnyObject {
    
    func bannerForItem(at indexPath: IndexPath, in bannerCollectionView: BannerCollectionView) -> BannerType
    
    func numberOfBanners(in bannerCollectionView: BannerCollectionView) -> Int
}

