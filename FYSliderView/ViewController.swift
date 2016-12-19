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
    
    var pageingControllers:[UIViewController]{
        let zero = ZeroViewController()
        zero.title = "0没有文字,自定义pageControl(默认)"
        let first = FirstViewController()
        first.title = "1没有文字,自定义pageControl的样式及垂直滚动"
        let two = TwoViewController()
        two.title = "2没有文字,使用系统pageControl"
        let three = ThreeViewController()
        three.title = "3没有文字,改变系统pageControl的位置"
        let four = FourViewController()
        four.title = "4有文字,使用渐变色遮罩背景(默认)"
        let five = FiveViewController()
        five.title = "5有文字,使用半透明遮罩背景"
        let six = SixViewController()
        six.title = "6有文字,自定义文字大小/内边距/颜色"
        let seven = SevenViewController()
        seven.title = "7实现代理方法,触发点击回调方法"
        let eight = EightViewController()
        eight.title = "8无图,纯文字垂直轮播"
        let night = NightViewController()
        night.title = "9动态增加轮播图的页数"
        let ten = TenViewController()
        ten.title = "10更换pageControl动画样式"
        return [zero,first,two,three,four,five,six,seven,eight,night,ten]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        createView()
    }
    
    func initData(){
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
        return pageingControllers.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ID")
        cell?.textLabel?.text = pageingControllers[indexPath.row].title
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let vc = pageingControllers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


