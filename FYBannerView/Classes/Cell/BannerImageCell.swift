//
//  BannerImageCell.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2018/4/3.
//

import Foundation
import Kingfisher

//func color() -> UIColor {
//    switch arc4random() % 5 {
//    case 0:
//        return .black
//    case 1:
//        return .green
//    case 2:
//        return .blue
//    case 3:
//        return .yellow
//    case 4:
//        return .gray
//    default:
//        return .red
//    }
//}

final class BannerImageCell: BannerCollectionCell {
    
    let pictureView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = color()
        contentView.addSubview(pictureView)
//        pictureView.bounds = CGRect(x: 0, y: 0, width: 414.0, height: 200)
//        contentView.clipsToBounds = true
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attr = layoutAttributes as? BannerCollectionViewLayoutAttributes {
             pictureView.frame = attr.pictureFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with data: BannerType, at indexPath: IndexPath, and bannerCollectionView: BannerCollectionView) {
        
//        guard let displayDelegate = bannerCollectionView.bannerDisplayDelegate else { fatalError("bannerDisplayDelegate没有实现") }

        if case .photo(let urlStr) = data.data, let url = URL(string: urlStr) {
            pictureView.kf.setImage(with: url)
        }
        
        //FIXME: - 设置contentMode会导致图片尺寸改变, 不能撑满父视图, 还需要搭配contentView.clipsToBounds使用, 暂时注释
//        let contentMode = displayDelegate.imageContentMode(for: data, at: indexPath, in: bannerCollectionView)
//        pictureView.contentMode = .contentMode
    }
}
