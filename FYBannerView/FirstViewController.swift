//
//  FirstViewController.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/15.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,FYBannerCustomizable, FYBannerViewDelegate {

    
    var flag:Int = 0
    
    var bannerView:FYBannerView!
    
    var controlStyle: FYControlStyle {
        let position:FYPosition = (x:.marginRight(10), y:.centerY)
        var style = FYControlStyle()
        style.position = position
        return style
    }
    
    func getValue(index:Int, closure:@escaping (_ value:[String])-> Void) {
        DispatchQueue.global().async {
            //异步执行
            
            sleep(2)
            
            DispatchQueue.main.async {
                
                let model = ["http://www.uimaker.com/uploads/allimg/20170420/1492654311127739.jpg","http://www.uimaker.com/uploads/allimg/20170420/1492654311127739.jpg","http://www.uimaker.com/uploads/allimg/20170420/1492654311127739.jpg","http://www.uimaker.com/uploads/allimg/20170420/1492654311127739.jpg"]
                
                closure(model)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(x:0, y:100, width:view.bounds.width, height:200)
        bannerView = FYBannerView(frame: rect, option: self)
        bannerView.backgroundColor = UIColor.black
        bannerView.delegate = self
        view.addSubview(bannerView)
        
        getValue(index: 0) { (value) in
            self.bannerView.dataSource = value
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerView(at index: Int) {
//        print(index)
    }
    
    func bannerView(to index: Int) {
//        print(index)
    }

}
