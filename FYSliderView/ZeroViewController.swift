//
//  ZeroViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/10.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class ZeroViewController: UIViewController,FYSliderViewCustomizable {
    
    var dataSource:[FYImageObject]!
    var sliderView:FYSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
        setupSliderView()
    }
    
    func initData(){
        let imageObj1 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic0.jpg" ,title:"")
        
        let imageObj2 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic1.jpg" ,title:nil)
        
        let imageObj3 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic2.jpg" ,title:"")
        
        let imageObj4 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic5.jpg" ,title:nil)
        
        dataSource = [imageObj1,imageObj2,imageObj3,imageObj4] //
    }
    
    func setupSliderView(){
        automaticallyAdjustsScrollViewInsets = false
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 200),option:self)
        view.addSubview(sliderView)
        sliderView.imageObjectGroup = dataSource
    }
    //MARK: - FYSliderView配置信息
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}