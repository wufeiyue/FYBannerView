//
//  FYSliderViewCell.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit
import Kingfisher

public class FYTextInsetsLabel:UILabel{
    public var textInsets:UIEdgeInsets = UIEdgeInsets.zero
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
    
}

public class FYCollectionViewCell: UICollectionViewCell {
    
    public var data:FYDataModel!
    public var placeholderImage:UIImage!
    public var imageContentMode:UIViewContentMode!
    
    public var hasConfigured:Bool!
    public var textLabel:FYTextInsetsLabel!
    
    public var labelHeight:CGFloat = 44
    public var colors:[UIColor]!
    public var maskHeight:CGFloat!
    
    fileprivate var imageView:UIImageView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createView(){
        
        imageView = UIImageView()
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        textLabel = FYTextInsetsLabel()
        textLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 1
        contentView.addSubview(textLabel)
    }
    
    public func draw(){
        
        if let title = data.title, title.characters.count > 0{
            textLabel.isHidden = false
            textLabel.text = title
        }else{
            textLabel.isHidden = true
        }
        
        if let url = data.url, url.characters.count > 0{
            imageView.isHidden = false
            
            //图片异步缓存库默认使用的是Kingfisher，如果使用的是SDWebImage请替换成下面注释行
            imageView.kf.setImage(with: URL(string: url), placeholder: placeholderImage, options: .none, progressBlock: nil)
            
            //            imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
            
        }else{
            imageView.isHidden = true
            
        }
        
        imageView.contentMode = imageContentMode
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(x: 0, y: self.bounds.size.height - labelHeight, width: self.bounds.size.width, height: labelHeight)
        
        imageView.frame = self.bounds
        
    }
}

public class FYTranslucentCell:FYCollectionViewCell{
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard data.title != nil && data.url != nil else{
            textLabel.backgroundColor = UIColor.clear
            return
        }
        
        textLabel.backgroundColor = colors.first
    }
}

public class FYGradientCell:FYCollectionViewCell{
    
    lazy private var gradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()//渐变背景
    
    fileprivate override func createView() {
        super.createView()
        imageView.layer.addSublayer(gradientLayer)
    }
    
    override public func draw() {
        super.draw()
        guard data.title != nil && data.url != nil else{
            gradientLayer.isHidden = true
            return
        }
        
        gradientLayer.isHidden = false
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.colors = self.colors.map{return $0.cgColor}
        gradientLayer.bounds = CGRect(x:0, y: 0, width:self.bounds.size.width, height:maskHeight)
        gradientLayer.position = CGPoint(x:0 , y: self.bounds.size.height - maskHeight)
        gradientLayer.anchorPoint = CGPoint.zero
    }
}
