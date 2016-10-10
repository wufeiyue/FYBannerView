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

typealias FYLayout = [FYPageControlStyle]
typealias FYPoint = (x:FYPotionsX, y:FYPotionsY)
typealias FYTitleStyle = [FYTitleLabelStyle]

struct FYImageObject {
    var url:String?
    var title:String?
}

class FYSliderView: UIView {

    let option:FYSliderViewCustomizable
    weak var delegate:FYSliderViewDelegate?
    var imageObjectGroup:[FYImageObject]! {
        willSet{
            totalImageCount = option.infiniteLoop == true ? newValue.count * 2 : newValue.count
            
            if newValue.count == 0 {
                self.backgroundImage.image = option.placeholderImage
                self.collectionView.scrollEnabled = false
            }else{
                self.backgroundImage.removeFromSuperview()
                self.collectionView.scrollEnabled = true
                
                if let control = pageControl as? FYPageControl {
                    control.numberOfPages = newValue.count
                }
                
                if let control = pageControl as? UIPageControl {
                    control.numberOfPages = newValue.count
                }
            }
            
        }
        
        didSet{
            if option.autoScroll && imageObjectGroup.count > 1 {
                self.setupTimer()
            }
            
        }
        
        
    }//图片对象
    
    private var pageControl:UIControl?
    private var pageControlLayout:FYLayout?
    private var totalImageCount:Int = 0
    private var timer:NSTimer!
    private var indexOnPageControl:Int = Int.max
    private var collectionView:UICollectionView!
    private lazy var flowLayout:UICollectionViewFlowLayout = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    private lazy var backgroundImage:UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .ScaleAspectFill
        return bgImageView
    }()
    
    init(frame: CGRect,option:FYSliderViewCustomizable) {
        self.option = option
        super.init(frame: frame)
        layer.contents = option.placeholderImage.CGImage
        setupCollectionView()
        setupPageControl()
        addChildView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupPageControl()
        addChildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func addChildView(){
        addSubview(collectionView)
        addSubview(backgroundImage)
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
        collection.registerClass(FYGradientCell.self, forCellWithReuseIdentifier: FYGradientCell.cellReuseIdentifier())
        collection.registerClass(FYTranslucentCell.self, forCellWithReuseIdentifier: FYTranslucentCell.cellReuseIdentifier())
        
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
        return index % imageObjectGroup.count
    }
    
    private func invalidateTimer(){
        guard timer != nil else {return}
        timer.invalidate()
        timer = nil
    }
    
    private func setupTimer(){
        let timer = NSTimer.scheduledTimerWithTimeInterval(option.scrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.timer = timer
    }
    
    //定时器
    func automaticScroll(){
        if totalImageCount == 0 {return}
        let currentIndex = self.currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(currentIndex)
        let targetIndex = indexOnPageControl + 1
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: true)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        let Height  = bounds.size.height
        let Width   = bounds.size.width
        let Size    = bounds.size
        let CenterX = center.x
        let CenterY = center.y
        flowLayout.itemSize = Size
        flowLayout.scrollDirection = option.scrollDirection
        
        backgroundImage.frame = bounds
        collectionView.frame = bounds

        if let layout = self.pageControlLayout {
            
            var offsetX:CGFloat = 0
            var offsetY:CGFloat = 0
            var width:CGFloat   = 0
            var height:CGFloat  = 0
 
            if let systemControl = pageControl as? UIPageControl {
            
                width = systemControl.sizeForNumberOfPages(imageObjectGroup.count).width
                height = systemControl.subviews.first?.frame.size.height ?? 0
                systemControl.frame.size = CGSize(width: width, height: height)
            
            }else if let customControl = pageControl as? FYPageControl {
                
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
                
               
                customControl.dotWidth = pageSize.circle
                customControl.borderWidth = pageSize.border
                width = customControl.sizeForNumberOfPages(imageObjectGroup.count).width
                height = pageSize.circle
                customControl.margin = pageMargin
                customControl.updateDots()
                
                
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
        
        
        if collectionView.contentOffset.x == 0 && totalImageCount != 0 {
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .None, animated: false)
        }
        
    }

    deinit{
        print("被销毁")
        timer = nil
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
 
}

extension FYSliderView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:FYCollectionViewCell!
        
        switch option.maskType {
        case .translucent(let backgroundColor):
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(FYTranslucentCell.cellReuseIdentifier(), forIndexPath: indexPath) as! FYTranslucentCell
          
            cell.colors = [backgroundColor]
            
            break
        case .gradient(let backgroundColors ,let offsetY):
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(FYGradientCell.cellReuseIdentifier(), forIndexPath: indexPath) as? FYGradientCell
            
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
            
            configCellAbloutTitlte(cell)
            
        }
        
        cell.draw()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(indexPath.item)
        if self.delegate != nil {
            self.delegate?.sliderView?(didSelectItemAtIndex: indexOnPageControl)
        }
    }
}

extension FYSliderView:UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
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
                collectionView.contentOffset.x = 0
            }
        }

    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if option.autoScroll && option.infiniteLoop{
            setupTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.collectionView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if option.autoScroll && option.infiniteLoop{
            invalidateTimer()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isEqual(self.collectionView) != true {return}
        if imageObjectGroup.isEmpty {return}
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(itemIndex)
        guard self.indexOnPageControl != indexOnPageControl else{
            return
        }
        
        if let control = pageControl as? FYPageControl {
            control.currentPage = indexOnPageControl
        }
        
        if let control = pageControl as? UIPageControl {
            control.currentPage = indexOnPageControl
        }
        
        self.indexOnPageControl = indexOnPageControl

    }
    
}

private func === (lhs: FYPageControlStyle, rhs: FYPageControlStyle) -> Bool {
    switch (lhs, rhs) {
    case (.point, .point): return true
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



