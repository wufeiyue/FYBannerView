//
//  ViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView:UITableView!
    var dataSource:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        createView()
    }
    
    func initData(){
        dataSource = ["没有文字,自定义pageControl(默认)",
                      "没有文字,改变自定义pageControl的大小和位置",
                      "没有文字,使用系统pageControl",
                      "没有文字,改变系统pageControl的位置",
                      "有文字,使用渐变色遮罩背景(默认)",
                      "有文字,使用半透明遮罩背景",
                      "有文字,自定义文字大小/内边距/颜色",
                      "实现代理方法,触发点击回调方法",]

        title = "FYSliderView"
    }
    
    func createView(){
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ID")
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ID")
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(ZeroViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(FirstViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(TwoViewController(), animated: true)
        case 3:
            navigationController?.pushViewController(ThreeViewController(), animated: true)
        case 4:
            navigationController?.pushViewController(FourViewController(), animated: true)
        case 5:
            navigationController?.pushViewController(FiveViewController(), animated: true)
        case 6:
            navigationController?.pushViewController(SixViewController(), animated: true)
        default:
            navigationController?.pushViewController(SevenViewController(), animated: true)
        }
        
    }
}


