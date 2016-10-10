//
//  FYCollectionViewCell.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit
import Kingfisher



public class FYTextInsetsLabel:UILabel{
    public var textInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    override public func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, textInsets))
    }
    
}

public class FYCollectionViewCell: UICollectionViewCell {
    
    public var data:FYImageObject!
    public var placeholderImage:UIImage!
    public var imageContentMode:UIViewContentMode!
    
    public var hasConfigured:Bool!
    public var textLabel:FYTextInsetsLabel!

    public var labelHeight:CGFloat = 44
    public var colors:[UIColor]!
    public var maskHeight:CGFloat!
    
    private var imageView:UIImageView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView(){
    
        imageView = UIImageView()
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)

        textLabel = FYTextInsetsLabel()
        textLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.font = UIFont.systemFontOfSize(16)
        textLabel.numberOfLines = 1
        contentView.addSubview(textLabel)
    }

    public func draw(){
        
        if let title = data.title where title.characters.count > 0{
            textLabel.hidden = false
            textLabel.text = title
        }else{
            textLabel.hidden = true
        }
        
        if let url = data.url where url.characters.count > 0{
            
            //图片异步缓存库默认使用的是Kingfisher，如果使用的是SDWebImage请替换成下面注释行
            imageView.kf_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage, optionsInfo: .None, progressBlock: nil)
            
//            imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
            
        }else{
            imageView.image = placeholderImage
        }
        
        imageView.contentMode = imageContentMode
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(x: 0, y: self.bounds.size.height - labelHeight, width: self.bounds.size.width, height: labelHeight)
        
        imageView.frame = self.bounds

    }
    
    //cell的标示符
    public static func cellReuseIdentifier() -> String {
        return self.classForCoder().description()
    }

}

public class FYTranslucentCell:FYCollectionViewCell{
    private override func createView() {
        super.createView()
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        textLabel.backgroundColor = colors.first
    }
}

public class FYGradientCell:FYCollectionViewCell{
    
    private lazy var gradientLayer:CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()//渐变背景
    
    private override func createView() {
        super.createView()
        imageView.layer.addSublayer(gradientLayer)
    }
    
    override public func draw() {
        super.draw()
        guard data.title?.characters.count > 0 else{
            gradientLayer.hidden = true
            return
        }
        gradientLayer.hidden = false
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.colors = self.colors.map{return $0.CGColor}
        gradientLayer.bounds = CGRect(x:0, y: 0, width:self.bounds.size.width, height:maskHeight)
        gradientLayer.position = CGPoint(x:0 , y: self.bounds.size.height - maskHeight)
        gradientLayer.anchorPoint = CGPoint.zero
    }
}
