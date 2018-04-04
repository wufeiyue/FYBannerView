//
//  FYBannerView.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2018/1/22.
//

import UIKit

open class FYBannerView: BaseBannerView {
    
    public weak var delegate: BannerViewDelegate?
    
    //FIXME: - 后面要优化
    var numberOfItems: Int = 0
    
    public var dataList = Array<BannerType>() {
        didSet {
            
            var imagesCount: Int = dataList.count
            
            if option.infiniteLoop && dataList.count != 1 {
                imagesCount = dataList.count * 2
            }
            
            self.numberOfItems = imagesCount
            
            invalidateTimer()
            
            if option.isAutoScroll && dataList.count > 1 {
                setupTimer(timeInterval: 4)
            }
            
            collectionView.reloadData()
            
            //TODO: 给pageControl.numberOfPages = dataList.count
            pageControl.numberOfPages = dataList.count
        }
    }
    
    internal var timer: Timer?
    internal weak var option: BannerCustomizable!
    
    open var pageControl: BannerPageControl = BannerPageControl()
    
    public init(frame: CGRect, option: BannerCustomizable) {
        super.init(frame: frame)
        self.option = option
        
        collectionView.bannerDataSource = self
        collectionView.bannerDisplayDelegate = self
        collectionView.bannerLayoutDelegate = self
        collectionView.setScrollDirection(option.scrollDirection)
        
        pageControl.style = option.controlStyle
        setPageControlConstraints()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            invalidateTimer()
        }
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        addSubview(pageControl)
    }
    
    
    func timerElamsed() {
        let currentIndex = collectionView.currentIndex
//        print("currentIndex-timerElamsed:\(currentIndex)")
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: currentIndex)
        let targetIndex = indexOnPageControl + 1
        collectionView.scrollToIndex(index: targetIndex, animated: true)
    }
    
    func pageControlIndexWithCurrentCellIndex(index: Int) -> Int {
        let num = dataList.count
        return num == 0 ? 0 : (index % num)
    }
    
    func setPageControlConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        switch option.controlStyle.position {
        case (.centerX, .marginBottom(let bvalue)):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                            NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bvalue)])
            break
        case (.centerX, .marginTop(let tvalue)):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                            NSLayoutConstraint(item: pageControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: tvalue)])
            break
        case (.centerX, .centerY):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                            NSLayoutConstraint(item: pageControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
            break
        case (.marginLeft(let lvalue), .marginBottom(let bvalue)):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: lvalue),
                            NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bvalue)])
            break
        case (.marginLeft(let lvalue), .marginTop(let tvalue)):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: lvalue),
                            NSLayoutConstraint(item: pageControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: tvalue)])
            break
        case (.marginLeft(let lvalue), .centerY):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: lvalue),
                            NSLayoutConstraint(item: pageControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
            break
        case (.marginRight(let rvalue), .marginBottom(let bvalue)):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: rvalue),
                            NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bvalue)])
            break
        case (.marginRight(let rvalue), .marginTop(let tvalue)):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: rvalue),
                            NSLayoutConstraint(item: pageControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: tvalue)])
            break
        case (.marginRight(let rvalue), .centerY):
            addConstraints([NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: rvalue),
                            NSLayoutConstraint(item: pageControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)])
            break
        }
    }
    
    required public init?(coder aDecoder: NSCoder) { return nil }
}

extension FYBannerView: BannerLayoutDelegate, BannerDataSource, BannerDisplayDelegate {
    
    public func numberOfBanners(in bannerCollectionView: BannerCollectionView) -> Int {
        //FIXME: - 尽量去掉它, 换成dataList.count
        return numberOfItems
    }
    
    public func bannerForItem(at indexPath: IndexPath, in bannerCollectionView: BannerCollectionView) -> BannerType {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: indexPath.section)
        return dataList[indexOnPageControl]
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: indexPath.section)
        delegate?.bannerView(self, at: indexOnPageControl)
    }
}

