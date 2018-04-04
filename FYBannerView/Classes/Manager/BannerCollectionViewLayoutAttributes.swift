//
//  BannerCollectionViewLayoutAttributes.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

final class BannerCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var pictureFrame: CGRect = .zero
    
    var titleFrame: CGRect = .zero
    
    var containerFrame: CGRect = .zero
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! BannerCollectionViewLayoutAttributes
        copy.containerFrame = containerFrame
        copy.titleFrame = titleFrame
        copy.pictureFrame = pictureFrame
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let _ = object as? BannerCollectionViewLayoutAttributes {
            return super.isEqual(object)
        }
        else {
            return false
        }
    }
}

