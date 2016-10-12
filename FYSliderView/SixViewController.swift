//
//  SixViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/10.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class SixViewController: Base2VC,FYSliderViewCustomizable {
    
    
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
    var titleStyle: FYTitleStyle{
        return [.textColor(UIColor.yellowColor()),.textInsets(UIEdgeInsetsMake(0, 30, 0, 180))]
    }
    
    var controlType: FYPageControlType{
        return .custom(currentColor:UIColor(red: 1, green: 1, blue: 1, alpha: 1) , normalColor:UIColor(red: 1, green: 1, blue: 1, alpha: 0.8),layout:[.point(x:.right(10), y:.bottom(13))])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}