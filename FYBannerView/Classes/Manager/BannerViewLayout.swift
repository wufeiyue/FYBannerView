//
//  BannerViewLayout.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import UIKit

public typealias BannerID = String
public typealias BannerViewScrollDirection = UICollectionView.ScrollDirection

open class BannerViewLayout: UICollectionViewFlowLayout {
    
    fileprivate var intermediateAttributesCache: [BannerID: BannerIntermediateLayoutAttributes] = [:]
    
    var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.size.width - sectionInset.left - sectionInset.right
    }
    
    var itemHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.size.height - sectionInset.top - sectionInset.bottom
    }
    
    fileprivate var bannerDataSource: BannerDataSource {
        guard let dataSource = bannerCollectionView.bannerDataSource else { fatalError("bannerDataSource没有实现") }
        return dataSource
    }
    
    fileprivate var bannerCollectionView: BannerCollectionView {
        guard let collectionView = collectionView as? BannerCollectionView else { fatalError("强转CollectionView失败") }
        return collectionView
    }
    
    public override init() {
        super.init()
        sectionInset = .zero
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let attr = bannerIntermediateLayoutAttributes(for: indexPath)
        return CGSize(width: itemWidth, height: attr.itemHeight)
    }
    
    public func removeAllCachedAttributes() {
        intermediateAttributesCache.removeAll()
    }
}

extension BannerViewLayout {
    
    func bannerIntermediateLayoutAttributes(for indexPath: IndexPath) -> BannerIntermediateLayoutAttributes {
        
        let banner = bannerDataSource.bannerForItem(at: indexPath, in: bannerCollectionView)
        
        if let intermediateAttributes = intermediateAttributesCache[banner.bannerId] {
            return intermediateAttributes
        }
        else {
            let newAttributes = createBannerIntermediateLayoutAttributes(indexPath: indexPath, data: banner)
            intermediateAttributesCache[banner.bannerId] = newAttributes
            return newAttributes
        }
    }
    
    func createBannerIntermediateLayoutAttributes(indexPath: IndexPath, data: BannerType) -> BannerIntermediateLayoutAttributes {
        
        var attributes = BannerIntermediateLayoutAttributes()
        
        attributes.itemHeight = itemHeight
        attributes.itemWidth = itemWidth
        
        return attributes
    }
}

extension BannerViewLayout {
    
    open override class var layoutAttributesClass: AnyClass {
        return BannerCollectionViewLayoutAttributes.self
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attributesList = super.layoutAttributesForElements(in: rect) as? [BannerCollectionViewLayoutAttributes] else {
            return nil
        }
        
        attributesList.forEach { attr in
            if attr.representedElementCategory == .cell {
                confiure(attributes: attr)
            }
        }
        
        return attributesList
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? BannerCollectionViewLayoutAttributes else { return nil }
        
        if attributes.representedElementCategory == .cell {
            confiure(attributes: attributes)
        }
        
        return attributes
    }
    
    func confiure(attributes: BannerCollectionViewLayoutAttributes) {
        
        var intermediateAttributes = bannerIntermediateLayoutAttributes(for: attributes.indexPath)
        
        attributes.pictureFrame = intermediateAttributes.pictureFrame
    }
}

