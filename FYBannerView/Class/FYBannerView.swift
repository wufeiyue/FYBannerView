//
//  FYBannerView.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

open class FYBannerView: UIView {

    weak var delegate:FYBannerViewDelegate?
    
    public private(set) weak var option:FYBannerCustomizable!
    
    fileprivate var timer:Timer?
    
    lazy private var collectionViewLayout:UICollectionViewLayout = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = self.bounds.size
        flowLayout.scrollDirection = self.option.scrollDirection
        return flowLayout
    }()
    
    lazy open var collectionView:UICollectionView = { [unowned self] in
        
        let collectionView = UICollectionView(frame:self.bounds, collectionViewLayout: self.collectionViewLayout)
        collectionView.register(FYCollectionViewCell.self, forCellWithReuseIdentifier: "FYCollectionViewCellKey")
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = !self.option.infiniteLoop
        return collectionView
        
    }()
    
    lazy open var control:FYBannerControl = { [unowned self] in
        let control = FYBannerControl()
        control.controlStyle = self.option.controlStyle
        control.parentSize = self.bounds.size
        return control
    }()
    
    fileprivate var _dataSource = Array<String>()
    open var dataSource:Array<String>! {
        didSet{
            guard !(dataSource.isEmpty || _dataSource.elementsEqual(dataSource)) else{
                return
            }
            
            control.numberOfPages = dataSource.count
            
            if option.infiniteLoop && dataSource.count != 1{
                
                setContentOffset(index: 1)
                
                //无限循环,在数组首尾加一
                let first = dataSource.first
                let last = dataSource.last
                dataSource.insert(last!, at: 0)
                dataSource.append(first!)
            }else{
                setContentOffset(index: 0)
            }
            
            _dataSource = dataSource
            
            collectionView.reloadData()
            
            setupTimer()
        }
    }
    
    public init(frame: CGRect, option:FYBannerCustomizable) {
        super.init(frame: frame)
        self.option = option
        
        [collectionView, control].forEach{ addSubview($0) }
        
    }
    
    deinit {
//        print("BannerView dealloc")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            invalidateTimer()
        }
    }
    
    /** 停止定时器*/
    public func invalidateTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    /** 开启定时器*/
    fileprivate func setupTimer(){
        
        if self.timer == nil, option.autoScroll == true {
            let timer = Timer.scheduledTimer(timeInterval: option.scrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            
            RunLoop.main.add(timer, forMode:.commonModes)
            self.timer = timer
        }
        
    }
    
    /** 定时器执行的方法*/
    func automaticScroll(){
        
        guard currentIndex < dataSource.count - 1 else {
            invalidateTimer()
            return
        }
        
        scrollToIndex(index: currentIndex + 1, isAnimated: true)
    }
    
    func scrollToIndex(index:Int, isAnimated:Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isAnimated)
    }

    //MARK: - Core Methods

    public var currentIndex:Int{
        if option.scrollDirection == .horizontal {
            let index = (collectionView.contentOffset.x + frame.size.width * 0.5)/frame.size.width
            return max(0, Int(index))
        }
        else{
            let index = (collectionView.contentOffset.y + frame.size.height * 0.5)/frame.size.height
            return max(0, Int(index))
        }
    }
    
    fileprivate func pageControlIndex(with index:Int)-> Int{

        if index == _dataSource.count - 1 {
            return 0
        }
        else{
            return index - 1
        }

    }
    
    fileprivate func setContentOffset(index:Int){
        if option.scrollDirection == .horizontal {
            collectionView.contentOffset.x = bounds.size.width * CGFloat(index)
        }
        else{
            collectionView.contentOffset.y = bounds.size.height * CGFloat(index)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.contentInset = UIEdgeInsets.zero
    }
}

extension FYBannerView:UIScrollViewDelegate {
    //为什么不会再reloadData就触发这个方法，如果触发就不在autoScroll中 +1
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if option.infiniteLoop {
            if currentIndex < _dataSource.count - 1 {
//                print("current index:\(currentIndex)")
                control.currentPage = currentIndex - 1
            }
        }else{
            if currentIndex < _dataSource.count{
//                print("current index:\(currentIndex)")
                control.currentPage = currentIndex
            }
        }
    }
    
    /*
     每次拉到最后一张时，回到第2张的起始位置
     每次拉到1张时，回到倒数第2张的起始位置
     */
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        var index = 0
        
        defer {
            delegate?.bannerView(to: index)
        }
        
        guard option.infiniteLoop else {
            index = currentIndex
            return
        }
        
        index = pageControlIndex(with: currentIndex)
        
        if currentIndex >= _dataSource.count - 1 {
            setContentOffset(index: 1)
        }
        else if currentIndex < 1{
            setContentOffset(index: _dataSource.count - 2)
        }
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if option.autoScroll{
            setupTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(collectionView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if option.autoScroll{
            invalidateTimer()
        }
    }
}

extension FYBannerView:UICollectionViewDelegate,UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FYCollectionViewCellKey", for: indexPath) as! FYCollectionViewCell
        
        let model = dataSource[indexPath.row]
        let url = URL(string:model)
        cell.imageView.kf.setImage(with: url, placeholder: option.placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
        cell.imageView.contentMode = option.imageContentMode
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var index:Int {
            if option.infiniteLoop {
                return currentIndex - 1
            }
            else{
                return currentIndex
            }
        }
        
        delegate?.bannerView(at: index)
    }

}
