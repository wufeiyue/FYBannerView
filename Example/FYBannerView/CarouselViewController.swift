//
//  CarouselViewController.swift
//  FYBannerView_Example
//
//  Created by 武飞跃 on 2018/4/13.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import FYBannerView

class CarouselViewController: UIViewController {

    var collectionView: CarouselView!
    
    var baseWidth: CGFloat {
        return view.bounds.size.width / 7
    }
    
    var dataList: Array<BannerType>! {
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CarouseViewLayout()
        layout.itemSize = CGSize(width: baseWidth * 4, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: baseWidth)
        
        let rect = CGRect(x: 1.5 * baseWidth, y: 80, width: baseWidth * 5, height: 200)
        collectionView = CarouselView(frame: rect, layout: layout)
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = false
        collectionView.contentSize = CGSize(width: 2000, height: 0)
        collectionView.delegate = self
        collectionView.setup(baseWidth: baseWidth)
        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
        
        getData { (data) in
            self.dataList = data.map({ MockModel(origin: $0) })
        }
        
    }
    
    func pageControlIndexWithCurrentCellIndex(index: Int) -> Int {
        let num = dataList.count
        return num == 0 ? 0 : (index % num)
    }

    func getData(completion: @escaping (_ data: [[String: String]]) -> Void) {
        
        guard let url = URL(string: "http://7xt77b.com1.z0.glb.clouddn.com/fysliderview_notext.json") else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let data = data else { return }
                
                let dict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                
                let dataSource = dict["data"] as! [[String: String]]
                
                completion(dataSource)
            }
            
        }
        
        session.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CarouselViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let carouselView = scrollView as? CarouselView else { return }
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: carouselView.currentIndex)
        print("indexOnPageControl:\(indexOnPageControl)")
    }
}

class CarouseViewLayout: NSObject {
    
    var itemSize: CGSize = .zero
    
    var sectionInset: UIEdgeInsets = .zero
    
}

class CarouselView: UIScrollView {
    
    var reuseIdentifier = Dictionary<String, CarouselViewCell>()
    
    let layout: CarouseViewLayout
    
    init(frame: CGRect, layout: CarouseViewLayout) {
        self.layout = layout
        super.init(frame: frame)
    }
    
    func reloadData() {
        
    }
    
    func setup(baseWidth: CGFloat) {
        for i in 0..<5 {
            let cell = CarouselViewCell()
            cell.frame = CGRect(x: baseWidth * 5 * CGFloat(i), y: layout.sectionInset.top, width: baseWidth * 4, height: bounds.size.height - layout.sectionInset.top - layout.sectionInset.bottom)
            cell.backgroundColor = .blue
            addSubview(cell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 获取当前cell的索引值
    var currentIndex: Int {
        guard bounds != .zero else { return 0 }
        let index = (contentOffset.x + layout.itemSize.width * 0.5) / layout.itemSize.width
        return max(0, Int(index))
    }
    
}

class CarouselViewCell: UIView {
    
    func prepareForReuse() {
        
    }
    
    func viewDidLoad(_ animated: Bool) {
        
    }
    
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
    
}

protocol CarouselViewDataSource: class {
    func numberOfSections(in carouselView: CarouselView) -> Int
    func carouselView(_ carouselView: CarouselView, cellForItemAt indexPath: Int) -> CarouselViewCell
}
