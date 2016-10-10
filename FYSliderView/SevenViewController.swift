//
//  SevenViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/10.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class SevenViewController: UIViewController,FYSliderViewCustomizable {
        
    var datas:[FYImageObject]!
    var sliderView:FYSliderView!
    
    var showLabel:UILabel!
    var textString:String!{
        willSet{
            showLabel.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
        setupSliderView()
        
        setupShowLabel()
    }
    
    func initData(){
        let imageObj1 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic0.jpg" ,title:"“十一”旅游“红黑榜”发布")
        
        let imageObj2 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic1.jpg" ,title:"国庆黄金周出境游是去年的两倍")
        
        let imageObj3 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic2.jpg" ,title:"韶山获评为全国旅游“综合秩序最佳景区”")
        
        let imageObj4 = FYImageObject(url:"http://www.wufeiyue.com/wp-content/uploads/2016/10/pic5.jpg" ,title:"国庆黄金周合肥接待游客1287万 ")
        
        datas = [imageObj1,imageObj2,imageObj3,imageObj4] //
    }
    
    func setupSliderView(){
        automaticallyAdjustsScrollViewInsets = false
        sliderView = FYSliderView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 200),option:self)
        view.addSubview(sliderView)

        sliderView.delegate = self
        sliderView.imageObjectGroup = datas
    }
    //MARK: - FYSliderView配置信息
    var controlType: FYPageControlType{
        return .custom(currentColor:UIColor(red: 1, green: 1, blue: 1, alpha: 1) , normalColor:UIColor(red: 1, green: 1, blue: 1, alpha: 0.8),layout:[.point(x:.centerX, y:.bottom(16))])
    }
    
    func setupShowLabel(){
        showLabel = UILabel()
        showLabel.frame.size = CGSize(width: 100, height: 40)
        showLabel.center = view.center
        showLabel.textColor = UIColor.whiteColor()
        showLabel.backgroundColor = UIColor.grayColor()
        showLabel.font = UIFont.systemFontOfSize(18)
        showLabel.textAlignment = .Center
        showLabel.text = "显示值"
        view.addSubview(showLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        
}

extension SevenViewController:FYSliderViewDelegate{
    func sliderView(didScrollToIndex index: Int) {
        textString = "滚到了\(index)"
    }
    
    func sliderView(didSelectItemAtIndex index: Int) {
        textString = "点击了\(index)"
    }
}