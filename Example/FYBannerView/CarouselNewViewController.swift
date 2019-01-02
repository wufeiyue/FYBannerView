//
//  CarouselNewViewController.swift
//  FYBannerView_Example
//
//  Created by 武飞跃 on 2018/9/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class CarouselNewViewController: UIViewController {
    
    var carouseNewView: CarouselNewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let carouseNewView = CarouselNewView(frame: CGRect(x: 0, y: 200, width: view.bounds.size.width, height: 200))
        view.addSubview(carouseNewView)
    }
    
    
    
}

struct CarouseNewViewLayout {
    
    var padding: CGFloat = 10
    var margin: CGFloat = 15
    
    let containerSize: CGSize
    
    init(containerSize: CGSize) {
        self.containerSize = containerSize
    }
    
    /// 滚动视图的宽度
    public var scrollViewWidth: CGFloat {
        return margin + contentViewWidth
    }
    
    /// 内容视图的宽度
    public var contentViewWidth: CGFloat {
        return containerSize.width - 2 * (padding + margin)
    }
    
    /// 滚动视图距离左侧父视图的边距
    public var scrollViewOriginX: CGFloat {
        return margin + padding
    }
}

extension CarouseNewViewLayout {
    
    public var scrollViewFrame: CGRect {
        return CGRect(x: scrollViewOriginX, y: 0, width: scrollViewWidth, height: containerSize.height)
    }
    
    public func contentViewFrame(index: Int) -> CGRect {
        
        let contentViewOriginX: CGFloat = scrollViewWidth * CGFloat(index)
        
        return CGRect(x: contentViewOriginX, y: 0, width: contentViewWidth, height: containerSize.height)
        
    }
}

public final class CarouselNewView: UIView {
    
    private var scrollView: UIScrollView!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.contentSize = CGSize(width: 2000, height: 0)
        scrollView.delegate = self
//        scrollView.setup(baseWidth: baseWidth)
        scrollView.backgroundColor = .red

        addSubview(scrollView)

        setupSubView()
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
    }
    
    func setupSubView() {
        
        let layoutStyle = CarouseNewViewLayout(containerSize: bounds.size)
        
        for i in 0..<5 {
            let cell = CarouselViewCell()
            cell.frame = layoutStyle.contentViewFrame(index: i)
            cell.backgroundColor = .blue
            scrollView.addSubview(cell)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let layoutStyle = CarouseNewViewLayout(containerSize: bounds.size)
//        layoutStyle.padding = 10
//        layoutStyle.margin = 15
        
        scrollView.frame = layoutStyle.scrollViewFrame
        
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        if object is UIScrollView {
        
//            let point = self.scrollView.contentOffset
            
//        }
        
    }
    
}

class CarouselScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CarouselNewView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    
}

