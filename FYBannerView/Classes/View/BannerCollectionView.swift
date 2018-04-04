//
//  BannerCollectionView.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import UIKit

open class BannerCollectionView: UICollectionView {
    
    weak var bannerDataSource: BannerDataSource?
    
    weak var bannerDisplayDelegate: BannerDisplayDelegate?
    
    weak var bannerLayoutDelegate: BannerLayoutDelegate?
    
    /// 获取当前cell的索引值
    var currentIndex: Int {
        
        guard bounds != .zero else { return 0 }
        
        var index: CGFloat = 0.0
        
        guard let layout = collectionViewLayout as? BannerViewLayout else { return 0 }
        
        //FIXME: - 有问题
        if case .horizontal = layout.scrollDirection {
            index = (contentOffset.x + layout.itemWidth * 0.5) / layout.itemWidth
        }
        else {
            index = (contentOffset.y + layout.itemHeight * 0.5) / layout.itemHeight
        }
        
        return max(0, Int(index))
    }
    
    func scrollToIndex(index: Int, animated: Bool) {
        //FIXME: - 移动的是section 不是item
        if visibleCells.isEmpty == false {
            scrollToItem(at: IndexPath(item: 0, section: index), at: .init(rawValue: 0), animated: animated)
        }
    }
    
    
    func reset() {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if case .horizontal = layout.scrollDirection {
            contentOffset.x = 0
        }
        else {
            contentOffset.y = 0
        }
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        scrollsToTop = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = true
        isPagingEnabled = true
        isDirectionalLockEnabled = true
        backgroundColor = .clear
    }
    
    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: BannerViewLayout())
    }
    
    public func setScrollDirection(_ direction: BannerViewScrollDirection) {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        layout.scrollDirection = direction
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

