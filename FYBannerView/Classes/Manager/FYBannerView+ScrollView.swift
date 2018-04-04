//
//  BannerData.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

extension FYBannerView {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let collectionView = scrollView as? BannerCollectionView else { return }
        
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: collectionView.currentIndex)
        
        //TODO: 赋值给pageControl.currentIndex 注意去重
        
        pageControl.currentPage = indexOnPageControl
        
//        print("currentIndex:\(collectionView.currentIndex)indexOnPageControl:\(indexOnPageControl)")
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        guard let collectionView = scrollView as? BannerCollectionView else { return }
        
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: collectionView.currentIndex)
        
        if option.infiniteLoop == false {
            if indexOnPageControl == (numberOfItems - 1) {
                invalidateTimer()
            }
        }
        else {
            if collectionView.currentIndex >= numberOfItems/2 {
                collectionView.reset()
            }
        }
        
        delegate?.bannerView(self, to: indexOnPageControl)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if option.isAutoScroll && option.infiniteLoop {
            setupTimer(timeInterval: 4)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(collectionView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if option.isAutoScroll && option.infiniteLoop {
            invalidateTimer()
        }
    }
}

