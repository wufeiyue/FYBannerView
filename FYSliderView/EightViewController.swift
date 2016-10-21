//
//  EightViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/21.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class EightViewController: Base2VC,FYSliderViewCustomizable {

    var sliderView:FYSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取网络数据
        getData { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            let dataSource = dic["data"] as! [[String:String]]
            
            self.sliderView.imageObjectGroup = dataSource.map({ dic in
                return FYImageObject(url: nil, title: dic["banner_title"])
            })
        }
        
        //初始化轮播图
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 40),option:self)
        view.addSubview(sliderView)
        
    }
    //MARK: - FYSliderView配置信息
    var scrollDirection: UICollectionViewScrollDirection{
        return .Vertical
    }
    
    var titleStyle: FYTitleStyle{
        return [.textColor(UIColor.blackColor()),.labelHeight(40)]
    }

    var controlType: FYPageControlType{
        return .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
