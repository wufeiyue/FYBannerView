//
//  FYSliderView.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

@objc public protocol FYSliderViewDelegate:class {
    //点击图片回调
    optional func sliderView(didSelectItemAtIndex index:Int) -> Void
    //图片滚动回调
    optional func sliderView(didScrollToIndex index:Int) -> Void
}

public typealias FYLayout = [FYPageControlStyle]
public typealias FYPoint = (x:FYPotionsX, y:FYPotionsY)
public typealias FYTitleStyle = [FYTitleLabelStyle]

public class FYSliderView: UIView {
    public private(set) weak var option:FYSliderViewCustomizable!
    //pageControl的宽度，配合自定义FYTitleStyle 避免标题文字过多遮盖住pageControl
    public private(set) var pageControlWidth:CGFloat!
    public weak var delegate:FYSliderViewDelegate?
    public var imageObjectGroup:[FYImageObject]! {
        
        didSet{

            guard let group = imageObjectGroup where group.count > 0 else{ return }
            
            totalImageCount = option.infiniteLoop == true && group.count != 1 ? group.count * 2 : group.count
            
            self.invalidateTimer()
            
            if option.autoScroll && group.count > 1 && oldValue != nil{
                self.setupTimer()
            }
            
            collectionView.reloadData()
            
            if let control = pageControl as? FYPageControl {
                control.numberOfPages = group.count
            }
            
            if let control = pageControl as? UIPageControl {
                control.numberOfPages = group.count
            }
            
        }
        
        
    }//图片对象
    
    private var pageControl:UIControl?
    private var pageControlLayout:FYLayout?
    private var totalImageCount:Int = 0
    private var timer:NSTimer!
    private var tempIndexOnPageControl:Int = Int.max
    private var collectionView:UICollectionView!
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    public init(frame: CGRect,option:FYSliderViewCustomizable) {
        self.option = option
        super.init(frame: frame)
        setupCollectionView()
        setupPageControl()
        addChildView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupPageControl()
        addChildView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addChildView(){
        addSubview(collectionView)
        if let pageControl = pageControl {
            addSubview(pageControl)
        }
    }
    
    private func setupCollectionView(){
        
        let collection = UICollectionView(frame:self.bounds,collectionViewLayout: self.flowLayout)
        collection.backgroundColor = UIColor.clearColor()
        collection.pagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.scrollsToTop = false
        collection.directionalLockEnabled = true
        collection.scrollEnabled = true
        collection.registerClass(FYGradientCell.self, forCellWithReuseIdentifier: "FYGradientCellIdentifier")
        collection.registerClass(FYTranslucentCell.self, forCellWithReuseIdentifier: "FYTranslucentCellIdentifier")
        self.collectionView = collection
    }
    
    private func setupPageControl(){
        
        if pageControl != nil {
            pageControl!.removeFromSuperview()
        }
        
        switch option.controlType {
        case .system(let current, let normal, let point):
            
            let control = UIPageControl()
            control.pageIndicatorTintColor = normal
            control.currentPageIndicatorTintColor = current
            control.hidesForSinglePage = option.hidesForSinglePage
            self.pageControl = control
            
            let tempStyle = FYPageControlStyle.point(x: point.x, y: point.y)
            self.pageControlLayout = FYLayout()
            self.pageControlLayout?.append(tempStyle)
            
            break
        case .custom(let current, let normal, let layout):
            
            let control = FYPageControl(pageIndicatorTintColor: normal,
                                        currentPageIndicatorTintColor: current,
                                        hidesForSinglePage: option.hidesForSinglePage)
            
            var pageMargin:CGFloat = 10
            var pageSize:(circle:CGFloat, border:CGFloat) = (circle:10, border:2)
            
            if let margin = layout.fy_equalAssociatedValue(.margin(0)),
                case .margin(let value) = margin {
                pageMargin = value
            }
            
            if let layoutSize = layout.fy_equalAssociatedValue(.size(borderWidth:0, circleWidth:0)),case .size(let size) = layoutSize {
                
                pageSize.border = size.borderWidth
                pageSize.circle = size.circleWidth
            }
            
            control.margin = pageMargin
            control.dotWidth = pageSize.circle
            control.borderWidth = pageSize.border
            
            self.pageControl = control
            self.pageControlLayout = layout
            break
        case .none:
            break
        }
    }
    
    private func currentIndex()-> Int{
        if collectionView.frame.size.width == 0 || collectionView.frame.size.height == 0 {
            return 0
        }
        
        var index:CGFloat = 0
        if flowLayout.scrollDirection == .Horizontal {
            index = (collectionView.contentOffset.x + flowLayout.itemSize.width * 0.5)/flowLayout.itemSize.width
        }else{
            index = (collectionView.contentOffset.y + flowLayout.itemSize.height * 0.5)/flowLayout.itemSize.height
        }
        return max(0, Int(index))
    }
    
    private func pageControlIndexWithCurrentCellIndex(index:Int)-> Int{
        let num = imageObjectGroup.count
        guard num != 0 else{ return 0 }
        return index % num
    }
    
    private func invalidateTimer(){
        guard timer != nil else {return}
        timer.invalidate()
        timer = nil
    }
    
    private func setupTimer(){
        
        if self.timer == nil {
            let timer = NSTimer.scheduledTimerWithTimeInterval(option.scrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            self.timer = timer
        }
        
    }
    
    //定时器
    func automaticScroll(){
        if totalImageCount == 0 {return}
        let currentIndex = self.currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(currentIndex)
        let targetIndex = indexOnPageControl + 1
        scrollToIndex(targetIndex,animated: true)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview == nil {
            invalidateTimer()
        }
    }
    
    private func configCellAbloutTitlte(cell:FYCollectionViewCell){
        let style = option.titleStyle
        
        if let fontSize = style.fy_equalAssociatedValue(.fontSize(0)),
            case .fontSize(let value) = fontSize {
            cell.textLabel.font = UIFont.systemFontOfSize(value)
        }
        
        if let textColor = style.fy_equalAssociatedValue(.textColor(UIColor.clearColor())),
            case .textColor(let value) = textColor {
            cell.textLabel.textColor = value
        }
        
        if let textInsets = style.fy_equalAssociatedValue(.textInsets(UIEdgeInsetsZero)),
            case .textInsets(let value) = textInsets {
            cell.textLabel.textInsets = value
        }
        
        if let labelHeight = style.fy_equalAssociatedValue(.labelHeight(0)),
            case .labelHeight(let value) = labelHeight {
            cell.labelHeight = value
        }
        
    }
    
    private func scrollToIndex(index:Int,animated:Bool){
        if totalImageCount != 0 && imageObjectGroup != nil &&  collectionView.visibleCells().count > 0{
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .None, animated: animated)
        }
    }
    
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let Height  = bounds.size.height
        let Width   = bounds.size.width
        let CenterX = center.x
        let CenterY = center.y
        flowLayout.itemSize = frame.size
        flowLayout.scrollDirection = option.scrollDirection
        
        
        collectionView.frame = bounds
        collectionView.contentInset = UIEdgeInsetsZero
        
        if let layout = self.pageControlLayout {
            
            var offsetX:CGFloat = 0
            var offsetY:CGFloat = 0
            var width:CGFloat   = 0
            var height:CGFloat  = 0
            
            if let systemControl = pageControl as? UIPageControl {
                if imageObjectGroup != nil{
                    width = systemControl.sizeForNumberOfPages(imageObjectGroup.count).width
                    pageControlWidth = width
                }
                height = systemControl.subviews.first?.frame.size.height ?? 0
                systemControl.frame.size = CGSize(width: width, height: height)
                
            }else if let customControl = pageControl as? FYPageControl {
                
                height = customControl.dotWidth
                
                if imageObjectGroup != nil{
                    width = customControl.sizeForNumberOfPages(imageObjectGroup.count).width
                    pageControlWidth = width
                }
                
                customControl.frame.size = CGSize(width:width, height:height)
                
            }
            
            
            if let positions = layout.fy_equalAssociatedValue(.point(x:.centerX,y:.centerY)),
                case .point(let point) = positions {
                
                switch point.y {
                case .bottom(let value):
                    offsetY = Height - value - height
                case .top(let value):
                    offsetY = value
                case .centerY:
                    offsetY = CenterY - height / 2
                }
                
                switch point.x {
                case .right(let value):
                    offsetX = Width - value - width
                case .left(let value):
                    offsetX = value
                case .centerX:
                    offsetX = CenterX - width / 2
                }
                
            }
            
            pageControl?.frame.origin = CGPoint(x: offsetX, y: offsetY)
        }
        
        if collectionView.contentOffset.x == 0 || collectionView.contentOffset.y == 0 {
            scrollToIndex(0,animated: false)
        }
        
        
    }
    
    deinit{
        print("sliderView被释放")
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
    
}

extension FYSliderView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCount
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:FYCollectionViewCell!
        
        switch option.maskType {
        case .translucent(let backgroundColor):
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("FYTranslucentCellIdentifier", forIndexPath: indexPath) as? FYTranslucentCell
            
            cell.colors = [backgroundColor]
            
            break
        case .gradient(let backgroundColors ,let offsetY):
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("FYGradientCellIdentifier", forIndexPath: indexPath) as? FYGradientCell
            
            cell.colors = backgroundColors
            cell.maskHeight = offsetY
            
            break
        }
        
        //配置数据
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(indexPath.item)
        let imageModel = imageObjectGroup[indexOnPageControl]
        cell.data = imageModel
        
        
        //配置参数
        if cell.hasConfigured == nil {
            cell.hasConfigured = true
            
            cell.placeholderImage = option.placeholderImage
            cell.imageContentMode = option.imageContentMode
            cell.clipsToBounds = true
            configCellAbloutTitlte(cell)
            
        }
        
        cell.draw()
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(indexPath.item)
        if self.delegate != nil {
            self.delegate?.sliderView?(didSelectItemAtIndex: indexOnPageControl)
        }
    }
    
    
}

extension FYSliderView:UIScrollViewDelegate{
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        if imageObjectGroup.isEmpty {return}
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        
        if self.delegate != nil {
            self.delegate?.sliderView?(didScrollToIndex: indexOnPageControl)
        }
        
        if option.infiniteLoop == false{
            if indexOnPageControl == totalImageCount - 1 {
                invalidateTimer()
                return
            }
        }else{
            if itemIndex >= totalImageCount/2 {
                if option.scrollDirection == .Horizontal {
                    collectionView.contentOffset.x = 0
                }else{
                    collectionView.contentOffset.y = 0
                }
            }
        }
        
        
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if option.autoScroll && option.infiniteLoop{
            setupTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.scrollViewDidEndScrollingAnimation(self.collectionView)
        
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if option.autoScroll && option.infiniteLoop{
            invalidateTimer()
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard let group = imageObjectGroup where group.count > 0 else{return}
        guard scrollView.isEqual(self.collectionView) else{return}
        
        
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        guard self.tempIndexOnPageControl != indexOnPageControl else{
            return
        }
        
        if let control = pageControl as? FYPageControl {
            control.currentPage = indexOnPageControl
        }
        
        if let control = pageControl as? UIPageControl {
            control.currentPage = indexOnPageControl
        }
        
        self.tempIndexOnPageControl = indexOnPageControl
        
    }
    
}

private func === (lhs: FYPageControlStyle, rhs: FYPageControlStyle) -> Bool {
    switch (lhs, rhs) {
    case (.point, .point):         return true
    case (.size,      .size):      return true
    case (.margin,    .margin):    return true
    default: return false
    }
}

private func === (lhs: FYTitleLabelStyle, rhs: FYTitleLabelStyle) -> Bool {
    switch (lhs, rhs) {
    case (.fontSize,        .fontSize):      return true
    case (.textColor,      .textColor):      return true
    case (.textInsets,    .textInsets):      return true
    case (.labelHeight,  .labelHeight):      return true
    default: return false
    }
}

extension CollectionType where Generator.Element == FYPageControlStyle {
    
    func fy_equalAssociatedValue(target: Generator.Element) -> Generator.Element? {
        return indexOf { $0 === target }.flatMap { self[$0] }
    }
    
}

extension CollectionType where Generator.Element == FYTitleLabelStyle {
    
    func fy_equalAssociatedValue(target: Generator.Element) -> Generator.Element? {
        return indexOf { $0 === target }.flatMap { self[$0] }
    }
    
}



