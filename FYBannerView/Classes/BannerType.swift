//
//  BannerType.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

public protocol BannerType {
    
    var bannerId: String { get }
    
    var data: BannerData { get }
}

public enum BannerData {
    
    //纯文本
    case text(String)
    
    //图片
    case photo(url: URL?, placeholder: UIImage?)
    
    //视频
    case video(file: URL, thumbnail: UIImage)
    
    //文字和图片
    case mutable(String, String)
}
