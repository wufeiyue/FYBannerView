//
//  ViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataSource:[FYImageObject]!
    var sliderView:FYSliderView!
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        
        setupSliderView()
    }
    
    func initData(){
        let imageObj1 = FYImageObject(url:"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg" ,title:"国足第一脚，就把外媒惊到了")
        
        let imageObj2 = FYImageObject(url:"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg" ,title:"国足第二脚，就把外媒惊到了")
        
        let imageObj3 = FYImageObject(url:"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg" ,title:"国足第三脚，就把外媒惊到了")
        
        dataSource = [imageObj1,imageObj2,imageObj3]
    }
    
    func setupSliderView(){
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200), delegate: self, placeholderImage: UIImage(named: "index_news_slide")!)
        sliderView.imageObjectGroup = dataSource
        sliderView.backgroundColor = UIColor.redColor()
        view.addSubview(sliderView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:FYSliderViewDelegate{
    func sliderView(didScrollToIndex index: Int) {
        
    }
    
    func sliderView(didSelectItemAtIndex index: Int) {
        
    }
}

