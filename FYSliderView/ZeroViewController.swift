//
//  ZeroViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/10.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class ZeroViewController: Base1VC,FYSliderViewCustomizable {
    
    
    var sliderView:FYSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSliderView()
    }
    
    //获得数据
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        let dic = try! NSJSONSerialization.JSONObjectWithData(networkData, options: .MutableContainers)
        let dataSource = dic["data"] as! [[String:String]]
        
        self.sliderView.imageObjectGroup = dataSource.map({ dic in
            return FYImageObject(url: dic["banner_picture_url"], title: dic["banner_title"])
        })
        
    }
    
    func setupSliderView(){
        automaticallyAdjustsScrollViewInsets = false
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 200),option:self)
        view.addSubview(sliderView)
        
    }
    //MARK: - FYSliderView配置信息
    
    deinit{
//        print("被释放")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}