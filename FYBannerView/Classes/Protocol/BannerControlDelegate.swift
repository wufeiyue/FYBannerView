//
//  TimerDelegate.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import Foundation

public protocol BannerControlDelegate: class {
    
    var numberOfPages: Int                               { get }
    var currentPage: Int                                 { get }
    var hidesForSinglePage: Bool                         { get }
    var defersCurrentPageDisplay: Bool                   { get }
    var pageIndicatorTintColor: UIColor?                 { get }
    var currentPageIndicatorTintColor: UIColor?          { get }
    
    func updateCurrentPageDisplay()
    func size(forNumberOfPages pageCount: Int) -> CGSize
}

