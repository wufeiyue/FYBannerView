//
//  FYCollectionViewCell.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class FYCollectionViewCell: UICollectionViewCell {
    
    var data:FYImageObject!
    private var titleLabel:UILabel!
    private var imageView:UIImageView!
    private var title:String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = randomColor()
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView(){
        titleLabel = UILabel(frame:contentView.bounds)
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(18)
        contentView.addSubview(titleLabel)
    }

    func draw(){
        titleLabel.text = data.title
    }
    //cell的标示符
    static func cellReuseIdentifier() -> String {
        return self.classForCoder().description()
    }
    
}

func randomColor() -> UIColor {
    
    func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
    return UIColor(red: random(), green: random(), blue: random(), alpha: random())
}

