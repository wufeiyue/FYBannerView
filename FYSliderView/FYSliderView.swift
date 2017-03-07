//
//  FYSliderView.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

@objc public protocol FYSliderViewDelegate:class {
    //点击图片回调
    @objc optional func sliderView(at index:Int)
    //图片滚动回调
    @objc optional func sliderView(to index:Int)
}

public typealias FYLayout = [FYPageControlStyle]
public typealias FYPoint = (x:FYPotionsX, y:FYPotionsY)
public typealias FYTitleStyle = [FYTitleLabelStyle]

open class FYSliderView: UIView {
    public private(set) weak var option:FYSliderViewCustomizable!
    //pageControl的宽度，配合自定义FYTitleStyle 避免标题文字过多遮盖住pageControl
    open private(set) var pageControlWidth:CGFloat!
    open weak var delegate:FYSliderViewDelegate?
    open var dataSource:[FYDataModel]! {
        
        didSet{
            
            guard let group = dataSource, group.count > 0 else{
                self.numberOfItems = 0
                self.invalidateTimer()
                collectionView.reloadData()
                pageControl?.isHidden = true
                return
            }
            
            var imagesCount:Int {
                if option.infiniteLoop == true && group.count != 1 {
                    return group.count * 2
                }else{
                    return group.count
                }
            }
            //cell个数
            self.numberOfItems = imagesCount
            
            //关闭定时器
            self.invalidateTimer()
            
            //默认打开自动滚动，并且在images个数大于1时，才允许开启定时器oldValue != nil
            if option.autoScroll && group.count > 1{
                self.setupTimer()
            }
            
            collectionView.reloadData()
            
            pageControl?.isHidden = false
            if let control = pageControl as? FYPageControl {
                control.numberOfPages = group.count
            }
            
            if let control = pageControl as? UIPageControl {
                control.numberOfPages = group.count
            }
            
        }
        
    }
    
    private var timer:Timer!
    fileprivate var pageControl:UIControl?
    fileprivate var pageControlLayout:FYLayout?
    fileprivate var numberOfItems:Int = 0
    fileprivate var tempIndexOnPageControl:Int = Int.max
    
    lazy fileprivate var collectionView:UICollectionView = {[unowned self] in
        let collection = UICollectionView(frame:self.bounds,collectionViewLayout: self.flowLayout)
        collection.backgroundColor = UIColor.clear
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.scrollsToTop = false
        collection.isDirectionalLockEnabled = true
        collection.isScrollEnabled = true
        collection.register(FYGradientCell.self, forCellWithReuseIdentifier: "FYGradientCellIdentifier")
        collection.register(FYTranslucentCell.self, forCellWithReuseIdentifier: "FYTranslucentCellIdentifier")
        return collection
    }()
    
    lazy fileprivate var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    public init(frame: CGRect,option:FYSliderViewCustomizable) {
        self.option = option
        super.init(frame: frame)
        setupPageControl()
        addChildView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupPageControl()
        addChildView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            invalidateTimer()
        }
    }
    
    private func addChildView(){
        addSubview(collectionView)
        if let pageControl = pageControl {
            addSubview(pageControl)
        }
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
        case .custom(let current, let normal, let layout, let animationType):
            
            let control = FYPageControl(pageIndicatorTintColor: normal,
                                        currentPageIndicatorTintColor: current,
                                        hidesForSinglePage: option.hidesForSinglePage)
            
            var pageMargin:CGFloat = 10
            var pageSize:(circle:CGFloat, border:CGFloat) = (circle:6, border:2)
            
            if let margin = layout.fy_equalAssociatedValue(target: .margin(0)),
                case .margin(let value) = margin {
                pageMargin = value
            }
            
            if let layoutSize = layout.fy_equalAssociatedValue(target: .size(borderWidth:0, circleWidth:0)),case .size(let size) = layoutSize {
                
                pageSize.border = size.borderWidth
                pageSize.circle = size.circleWidth
            }
            control.animationType = animationType
            control.margin = pageMargin
            control.dotWidth = pageSize.circle
            control.dotBorderWidth = pageSize.border
            control.animationDuration = option.scrollTimeInterval
            self.pageControl = control
            self.pageControlLayout = layout
            break
        case .none:
            break
        }
    }
    
    fileprivate func currentIndex()-> Int{
        if collectionView.frame.size.width == 0 || collectionView.frame.size.height == 0 {
            return 0
        }
        
        var index:CGFloat = 0
        
        if flowLayout.scrollDirection == .horizontal {
            index = (collectionView.contentOffset.x + flowLayout.itemSize.width * 0.5)/flowLayout.itemSize.width
        }else{
            index = (collectionView.contentOffset.y + flowLayout.itemSize.height * 0.5)/flowLayout.itemSize.height
        }
        
        return max(0, Int(index))
    }
    
    fileprivate func pageControlIndexWithCurrentCellIndex(index:Int)-> Int{
        let num = dataSource.count
        guard num != 0 else{ return 0 }
        return index % num
    }
    
    fileprivate func invalidateTimer(){
        guard timer != nil else {return}
        timer.invalidate()
        timer = nil
    }
    
    fileprivate func setupTimer(){
        
        if self.timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: option.scrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            
            RunLoop.main.add(timer, forMode:.commonModes)
            self.timer = timer
        }
        
    }
    
    //定时器
    func automaticScroll(){
        if numberOfItems == 0 {return}
        let currentIndex = self.currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: currentIndex)
        let targetIndex = indexOnPageControl + 1
        scrollToIndex(index: targetIndex,animated: true)
    }
    
    fileprivate func configCellAbloutTitlte(cell:FYCollectionViewCell){
        let style = option.titleStyle
        
        if let fontSize = style.fy_equalAssociatedValue(target: .fontSize(0)),
            case .fontSize(let value) = fontSize {
            cell.textLabel.font = UIFont.systemFont(ofSize: value)
        }
        
        if let textColor = style.fy_equalAssociatedValue(target: .textColor(UIColor.clear)),
            case .textColor(let value) = textColor {
            cell.textLabel.textColor = value
        }
        
        if let textInsets = style.fy_equalAssociatedValue(target: .textInsets(UIEdgeInsets.zero)),
            case .textInsets(let value) = textInsets {
            cell.textLabel.textInsets = value
        }
        
        if let labelHeight = style.fy_equalAssociatedValue(target: .labelHeight(0)),
            case .labelHeight(let value) = labelHeight {
            cell.labelHeight = value
        }
        
    }
    
    private func scrollToIndex(index:Int,animated:Bool){
        if numberOfItems != 0 && dataSource != nil &&  collectionView.visibleCells.count > 0{
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let Height  = bounds.size.height
        let Width   = bounds.size.width
        let CenterX = center.x
        let CenterY = center.y
        flowLayout.itemSize = frame.size
        flowLayout.scrollDirection = option.scrollDirection
        
        
        collectionView.frame = bounds
        collectionView.contentInset = UIEdgeInsets.zero
        
        if let layout = self.pageControlLayout {
            
            var offsetX:CGFloat = 0
            var offsetY:CGFloat = 0
            var width:CGFloat   = 0
            var height:CGFloat  = 0
            
            if let systemControl = pageControl as? UIPageControl {
                if dataSource != nil{
                    width = systemControl.size(forNumberOfPages: dataSource.count).width
                    pageControlWidth = width
                }
                height = systemControl.subviews.first?.frame.size.height ?? 0
                systemControl.frame.size = CGSize(width: width, height: height)
                
            }else if let customControl = pageControl as? FYPageControl {
                
                height = customControl.dotWidth
                
                if let group = dataSource{
                    width = customControl.sizeForNumberOfPages(pageCount: group.count).width
                    pageControlWidth = width
                }
                
            }
            
            
            if let positions = layout.fy_equalAssociatedValue(target: .point(x:.centerX,y:.centerY)),
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
            scrollToIndex(index: 0,animated: false)
        }
        
        
    }
    
    deinit{
//        print("sliderView被释放")
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
    }
    
}

extension FYSliderView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell:FYCollectionViewCell!
        
        switch option.maskType {
        case .translucent(let backgroundColor):
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FYTranslucentCellIdentifier", for: indexPath) as? FYTranslucentCell
            
            cell.colors = [backgroundColor]
            
            break
        case .gradient(let backgroundColors ,let offsetY):
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FYGradientCellIdentifier", for: indexPath) as? FYGradientCell
            
            cell.colors = backgroundColors
            cell.maskHeight = offsetY
            
            break
        }
        
        //配置数据
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
        let imageModel = dataSource[indexOnPageControl]
        cell.data = imageModel
        
        
        //配置参数
        if cell.hasConfigured == nil {
            cell.hasConfigured = true
            
            cell.placeholderImage = option.placeholderImage
            cell.imageContentMode = option.imageContentMode
            cell.clipsToBounds = true
            configCellAbloutTitlte(cell: cell)
            
        }
        
        cell.draw()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
        if self.delegate != nil {
            self.delegate?.sliderView!(at: indexOnPageControl)
        }
    }
    
}

extension FYSliderView:UIScrollViewDelegate{
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if dataSource.isEmpty {return}
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: itemIndex)
        
        if self.delegate != nil {
            self.delegate?.sliderView!(to: indexOnPageControl)
        }
        
        if option.infiniteLoop == false{
            if indexOnPageControl == numberOfItems - 1 {
                invalidateTimer()
                return
            }
        }else{
            if itemIndex >= numberOfItems/2 {
                if option.scrollDirection == .horizontal {
                    collectionView.contentOffset.x = 0
                }else{
                    collectionView.contentOffset.y = 0
                }
            }
        }
        
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if option.autoScroll && option.infiniteLoop{
            setupTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.scrollViewDidEndScrollingAnimation(self.collectionView)
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if option.autoScroll && option.infiniteLoop{
            invalidateTimer()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let group = dataSource, group.count > 0 else{return}
        guard scrollView.isEqual(self.collectionView) else{return}
        
        
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: itemIndex)
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
    case (.point,     .point):     return true
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

extension Collection where Iterator.Element == FYPageControlStyle {
    
    func fy_equalAssociatedValue(target: Iterator.Element) -> Iterator.Element? {
        return index { $0 === target }.flatMap { self[$0] }
    }
    
}

extension Collection where Iterator.Element == FYTitleLabelStyle {
    
    func fy_equalAssociatedValue(target: Generator.Element) -> Iterator.Element? {
        return index { $0 === target }.flatMap { self[$0] }
    }
    
}
