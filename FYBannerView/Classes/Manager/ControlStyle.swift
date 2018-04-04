//
//  ControlStyle.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//

import Foundation

public typealias ControlPosition = (x: ControlPositionX, y: ControlPositionY)

public enum ControlPositionY {
    case marginTop(_: CGFloat)
    case centerY
    case marginBottom(_: CGFloat)
}

extension ControlPositionY {
    var constraints: String {
        switch self {
        case .marginBottom(let value):
            return "V:[pageControl]-\(value)-|"
        case .marginTop(let value):
            return "V:|-\(value)-[pageControl]"
        case .centerY:
            return "V:|-[pageControl]-|"
        }
    }
}



public enum ControlPositionX {
    case marginLeft(_: CGFloat)
    case centerX
    case marginRight(_: CGFloat)
}

extension ControlPositionX {
    var constraints: String {
        switch self {
        case .marginLeft(let value):
            return "H:[pageControl]-\(value)-|"
        case .marginRight(let value):
            return "H:|-\(value)-[pageControl]"
        case .centerX:
            return "H:|-[pageControl]-|"
        }
    }
}

public enum BannerPageControlType {
    //圆环
    case ring
}

public struct BannerPageControlStyle {
    
    public var position: ControlPosition = (x:.centerX, y:.marginBottom(-10))
    
    public var type: BannerPageControlType = .ring
    
    public var borderWidth: CGFloat = 2
    public var cornerRadius: CGFloat = 3.5
    public var width: CGFloat = 7
    public var height: CGFloat = 7
    public var margin: CGFloat = 9
    
    public init() {}
}

extension BannerPageControlStyle {
    
    /// 获取control元素的位置
    ///
    /// - Parameter index: control元素的索引 (index从0开始)
    /// - Returns: control元素的位置
    func calcDotPosition(index:Int) -> CGPoint {
        
        let x = (width + margin) * CGFloat(index)
        return CGPoint(x:x ,y:0)
    }
    
    /// 获取control的尺寸
    ///
    /// - Parameter num: control元素的个数 (num从0开始)
    /// - Returns: size
    func calcDotSize(num:Int) -> CGSize {
        
        var size = CGSize.zero
        if num > 0 {
            size.width = width * CGFloat(num) + margin * CGFloat(num - 1)
        }
        size.height = height
        return size
    }
}
