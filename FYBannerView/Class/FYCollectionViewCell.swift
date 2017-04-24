//
//  FYCollectionViewCell.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/13.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit
import Kingfisher

class FYCollectionViewCell: UICollectionViewCell {
    
//    var titleLabel:UILabel!
    var imageView:UIImageView!
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createView(){
        
        imageView = UIImageView()
        
        contentView.addSubview(imageView)
        
//        titleLabel = UILabel()
//        titleLabel.textAlignment = .center
//        contentView.addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        titleLabel.frame = bounds
        imageView.frame = bounds
    }
    
}
