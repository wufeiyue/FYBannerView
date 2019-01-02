//
//  TableCellViewController.swift
//  FYBannerView_Example
//
//  Created by 武飞跃 on 2018/1/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import FYBannerView

class TableCellViewController: UIViewController {

    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCell.self, forCellReuseIdentifier: "TableCellKEY")
        view.addSubview(tableView)
    }

    deinit {
        print("TableCellViewController deinit")
    }
}

extension TableCellViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellKEY") as! TableCell
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "KEY")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "KEY")
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        else {
            return 44
        }
    }
}

class TableCell: UITableViewCell {
    
    var bannerView: FYBannerView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bannerView = FYBannerView(frame: .zero, option: self)
        contentView.addSubview(bannerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bannerView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}

extension TableCell: BannerCustomizable {
    
}
