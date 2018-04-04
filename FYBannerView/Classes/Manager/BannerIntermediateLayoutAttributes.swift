//
//  BannerIntermediateLayoutAttributes.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

//banner主要的布局管理
struct BannerIntermediateLayoutAttributes {
    
    var itemWidth: CGFloat = 0
    
    var itemHeight: CGFloat = 0
    
    lazy var pictureFrame: CGRect = {
        return CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight)
    }()
    
    //标题的外边距
    var titleLabelPaddig: UIEdgeInsets = .zero
    
    //标题的内边距
    var titleLabelInsets: UIEdgeInsets = .zero
}

