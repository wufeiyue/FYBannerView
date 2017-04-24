//
//  FYHelper.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

public typealias FYPosition = (x:FYPositionX, y:FYPositionY)

public enum FYPositionY {
    case marginTop(_:CGFloat)
    case centerY
    case marginBottom(_:CGFloat)
    
    static func `default`() -> FYPositionY {
        return .marginBottom(10)
    }
}

public enum FYPositionX {
    case marginLeft(_:CGFloat)
    case centerX
    case marginRight(_:CGFloat)
    
    static func `default`() -> FYPositionX {
        return .centerX
    }
}

extension FYPositionX {
   
    /// 计算水平方向的坐标
    ///
    /// - Parameters:
    ///   - eWidth: 控件自身的宽度
    ///   - pWidth: 父视图的宽度
    /// - Returns: 计算后的坐标
    func calc(element eWidth:CGFloat, parent pWidth:CGFloat) -> CGFloat {
        switch self {
        case .centerX:
            return (pWidth - eWidth)/2
        case .marginLeft(let value):
            return eWidth + value
        case .marginRight(let value):
            return pWidth - eWidth - value
        }
    }
}
extension FYPositionY {
    
    /// 计算垂直方向的坐标
    ///
    /// - Parameters:
    ///   - eHeight: 控件自身的高度
    ///   - pHeight: 父视图的高度
    /// - Returns: 计算后的坐标
    func calc(element eHeight:CGFloat, parent pHeight:CGFloat) -> CGFloat {
        switch self {
        case .centerY:
            return (pHeight - eHeight)/2
        case .marginTop(let value):
            return eHeight + value
        case .marginBottom(let value):
            return pHeight - eHeight - value
        }
    }
}
