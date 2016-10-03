//
//  FYSliderView.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

protocol FYSliderViewDelegate:class {
    //点击图片回调
    func sliderView(didSelectItemAtIndex index:Int) -> Void
    //图片滚动回调
    func sliderView(didScrollToIndex index:Int) -> Void
}

struct FYImageObject {
    var url:String
    var title:String
}

class FYSliderView: UIView {

    enum PageControlAliment {
        case left
        case right
        case center
    }
    
    enum PageControlStyle {
        case system
        case animated
        case none
    }
    
    
    
    weak var delegate:FYSliderViewDelegate?
    let placeholderImage:UIImage
    var imageObjectGroup:[FYImageObject]! {
        willSet{
            totalImageCount = shouldInfiniteLoop == true ? newValue.count * 10 : newValue.count
            
            if newValue.count == 0 {
                self.mainView.scrollEnabled = false
            }else{
                self.mainView.scrollEnabled = true
            }
            
        }
        
        didSet{
            self.setupTimer()
//            self.mainView.reloadData()
        }
        
        
    }//图片对象
    
    var scrollDirection:UICollectionViewScrollDirection! //滚动方向
    var shouldInfiniteLoop:Bool = true //默认无限循环
    var autoScroll:Bool = true //默认自动滚动
    
    var showPageControl:Bool = true //是否显示分页控件
    var hidesForSinglePage:Bool = true //是否在只有一张图时隐藏pagecontrol，默认为true
    
    var imageViewContentMode:UIViewContentMode! //图片的填充方式
    let autoScrollTimeInterval:NSTimeInterval = 2 //默认滚动间隔时间
    private var totalImageCount:Int = 0
    private lazy var mainView:UICollectionView = {
        let mainView = UICollectionView(frame:self.bounds,collectionViewLayout: self.flowLayout)
        mainView.backgroundColor = UIColor.clearColor()
        mainView.pagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        mainView.registerClass(FYCollectionViewCell.self, forCellWithReuseIdentifier: FYCollectionViewCell.cellReuseIdentifier())
        return mainView
    }()
    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        return flowLayout
    }()
    private weak var pageControl:UIPageControl!
    private var timer:NSTimer!
    private var backgroundImage:UIImage!{
        willSet{
            if !newValue.isEqual(backgroundImage) {
                let bgImageView = UIImageView()
                bgImageView.contentMode = .ScaleAspectFill
                insertSubview(bgImageView, belowSubview: mainView)
            }
        }
    }
    
    init(frame: CGRect, delegate:FYSliderViewDelegate, placeholderImage:UIImage) {
        self.delegate = delegate
        self.placeholderImage = placeholderImage
        super.init(frame: frame)
        initData()
        setupMainView()
    }
    
    init(frame: CGRect, placeholderImage:UIImage) {
        self.placeholderImage = placeholderImage
        super.init(frame: frame)
        initData()
        setupMainView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //清除图片缓存
    static func clearImageCache(){
        
    }
    
    private func initialization(){
        
    }
    
    private func initData(){
        
    }
    
    private func setupMainView(){
        addSubview(mainView)
    }
    
    
    
    private func currentIndex()-> Int{
        if mainView.frame.size.width == 0 || mainView.frame.size.height == 0 {
            return 0
        }
        
        var index:CGFloat = 0
        if flowLayout.scrollDirection == .Horizontal {
            index = (mainView.contentOffset.x + flowLayout.itemSize.width * 0.5)/flowLayout.itemSize.width
        }else{
            index = (mainView.contentOffset.y + flowLayout.itemSize.height * 0.5)/flowLayout.itemSize.height
        }
        
        return max(0, Int(index))
    }
    
    private func pageControlIndexWithCurrentCellIndex(index:Int)-> Int{
        return index % imageObjectGroup.count
    }
    
    
    private func invalidateTimer(){
        timer.invalidate()
        timer = nil
    }
    
    private func setupTimer(){
        let timer = NSTimer.scheduledTimerWithTimeInterval(autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.timer = timer
    }
    
    //定时器
    func automaticScroll(){
        if totalImageCount == 0 {return}
        let currentIndex = self.currentIndex()
        let targetIndex = currentIndex + 1
        scrollToIndex(targetIndex)
    }
    
    private func scrollToIndex(targetIndex:Int){
        if targetIndex >= totalImageCount {
            if shouldInfiniteLoop == true {
                let targetOffset:Int = totalImageCount/2
                mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetOffset, inSection: 0), atScrollPosition: .None, animated: false)
            }
            return
        }
        mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = frame.size
        mainView.frame = bounds
        if mainView.contentOffset.x == 0 && totalImageCount != 0 {
            var targetIndex = 0
            if self.shouldInfiniteLoop == true {
                targetIndex = totalImageCount / 2
            }else{
                targetIndex = 0
            }
            mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: false)
        }
        
//        let size = CGSize.zero
        
    }
    
    deinit{
        timer = nil
        mainView.dataSource = nil
        mainView.delegate = nil
    }
 
}

extension FYSliderView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FYCollectionViewCell.cellReuseIdentifier(), forIndexPath: indexPath) as! FYCollectionViewCell
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(indexPath.item)
        let imageModel = imageObjectGroup[indexOnPageControl]
        cell.data = imageModel
        cell.draw()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(indexPath.item)
        if self.delegate != nil {
            self.delegate?.sliderView(didScrollToIndex: indexOnPageControl)
        }
    }
}

extension FYSliderView:UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if !imageObjectGroup.isEmpty {return}
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        if self.delegate != nil {
            self.delegate?.sliderView(didScrollToIndex: indexOnPageControl)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            setupTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.mainView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.autoScroll {
            invalidateTimer()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !imageObjectGroup.isEmpty {return}
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        
        //选用系统pageControl
        pageControl.currentPage = indexOnPageControl
        
    }
}