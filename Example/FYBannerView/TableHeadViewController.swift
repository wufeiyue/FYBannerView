//
//  TableHeadViewController.swift
//  FYBannerView_Example
//
//  Created by 武飞跃 on 2018/1/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import FYBannerView

struct MockModel: BannerType {
    
    var bannerId: String
    
    var data: BannerData
    
    init(origin: [String: String]) {
        
        let urlStr = origin["banner_picture_url"]!
//        let title = origin["banner_title"]!
        
        bannerId = "\(urlStr.hashValue)"
        data = .photo(url: URL(string: urlStr), placeholder: UIImage(named: ""))
    }
}

class TableHeadViewController: UIViewController {

    var tableView:UITableView!
    var bannerView: FYBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200)
        bannerView = FYBannerView(frame: rect, option: self)
        bannerView.pageControl.normalColor = .red
        bannerView.pageControl.selectorColor = .gray
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = bannerView
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData { (data) in
            self.bannerView.dataList = data.map({ MockModel(origin: $0) })
        }
    }
    
    deinit {
        print("TableHeadViewController deinit")
    }
    
    func getData(completion: @escaping (_ data: [[String: String]]) -> Void) {
        
        guard let url = URL(string: "http://ppbntwsxr.bkt.gdipper.com/banner.json") else { return }
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
}

extension TableHeadViewController: BannerCustomizable {
    
    var controlStyle: BannerPageControlStyle {
        var style = BannerPageControlStyle()
        style.position.y = .marginBottom(10)
        return style
    }
    
}

extension TableHeadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "KEY")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "KEY")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
