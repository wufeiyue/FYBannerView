//
//  TenViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/11/29.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class TenViewController: Base1VC,FYSliderViewCustomizable {
    
    var sliderView:FYSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取网络数据
        getData { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            let dataSource = dic["data"] as! [[String:String]]
            
            self.sliderView.imageObjectGroup = dataSource.map({ dic in
                return FYImageObject(url: dic["banner_picture_url"], title: dic["banner_title"])
            })
        }
        
        //初始化轮播图
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 200),option:self)
        view.addSubview(sliderView)
    }
    
    //MARK: - FYSliderView配置信息
    var scrollTimeInterval: NSTimeInterval{
        return 4
    }
    
    var controlType: FYPageControlType{
        return .custom(currentColor:UIColor.redColor() , normalColor:UIColor.whiteColor(),layout:[.point(x:.centerX, y:.centerY)], animationType:.countdown)
    }
    

    deinit{
        print("TenViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
