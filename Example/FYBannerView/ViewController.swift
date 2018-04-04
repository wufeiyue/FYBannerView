//
//  ViewController.swift
//  FYBannerView
//
//  Created by eppeo on 01/22/2018.
//  Copyright (c) 2018 eppeo. All rights reserved.
//

import UIKit
import FYBannerView

class ViewController: UIViewController {

    var tableView:UITableView!
    var dataSource: Array<Model>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [Model(viewType: TableHeadViewController.self),
                      Model(viewType: TableCellViewController.self),
                      Model(viewType: TabBarViewController.self)]
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "KEY")
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KEY")
        cell?.textLabel?.text = dataSource[indexPath.row].title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = dataSource[indexPath.row].viewType
        navigationController?.pushViewController(type.init(), animated: true)
    }
}

struct Model {
    
    var viewType: UIViewController.Type
    
    var title: String {
        return String(describing: viewType)
    }
}

