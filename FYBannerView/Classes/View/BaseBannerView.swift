//
//  BaseBannerView.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2016/10/2.
//

import UIKit

open class BaseBannerView: UIView {
    
    var collectionView = BannerCollectionView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: "BannerImageCellKey")
        
    }
    
    open func setupSubviews() {
        addSubview(collectionView)
    }
    
    open func setupConstraints() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewMapping: [String : Any] = ["collectionView": collectionView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: collectionViewMapping))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: collectionViewMapping))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BaseBannerView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? BannerCollectionView else { return 0 }
        return collectionView.bannerDataSource?.numberOfBanners(in: collectionView) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? BannerCollectionView else { return 0 }
        let bannerCount = collectionView.bannerDataSource?.numberOfBanners(in: collectionView) ?? 0
        return bannerCount > 0 ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionView = collectionView as? BannerCollectionView else { fatalError("仅支持使用BannerCollectionView") }
        
        guard let bannerDataSource = collectionView.bannerDataSource else { fatalError("bannerDataSource不能为空, 协议必须实现") }
        
        let model = bannerDataSource.bannerForItem(at: indexPath, in: collectionView)
        
        switch model.data {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextMessageCellKey", for: indexPath) as! BannerCollectionCell
            cell.configure(with: model, at: indexPath, and: collectionView)
            return cell
        case .photo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCellKey", for: indexPath) as! BannerImageCell
            cell.configure(with: model, at: indexPath, and: collectionView)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextMessageCellKey", for: indexPath) as! BannerCollectionCell
            cell.configure(with: model, at: indexPath, and: collectionView)
            return cell
        }
    }
}

extension BaseBannerView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? BannerViewLayout else { return .zero }
//        print("size: \(layout.sizeForItem(at: indexPath))")
        return layout.sizeForItem(at: indexPath)
    }
}
