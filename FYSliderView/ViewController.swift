//
//  ViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FYSliderViewCustomizable {

    var dataSource:[FYImageObject]!
    var sliderView:FYSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        
        setupSliderView()
        
    }
    
    func initData(){
        let imageObj1 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic0.jpg" ,title:"“十一”旅游“红黑榜”发布")
        
        let imageObj2 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic1.jpg" ,title:"国庆黄金周出境游是去年的两倍")
        
        let imageObj3 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic2.jpg" ,title:"韶山获评为全国旅游“综合秩序最佳景区”")
        
        let imageObj4 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic5.jpg" ,title:"国庆黄金周合肥接待游客1287万 ")
        
        dataSource = [imageObj1,imageObj2,imageObj3,imageObj4] //
    }
    
    func setupSliderView(){
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200),option:self)
        sliderView.delegate = self
        sliderView.imageObjectGroup = dataSource
        view.addSubview(sliderView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:FYSliderViewDelegate{
    func sliderView(didScrollToIndex index: Int) {
        print("滚到了\(index)")
    }
    
    func sliderView(didSelectItemAtIndex index: Int) {
        print("点了\(index)")
    }
}

