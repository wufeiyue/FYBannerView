//
//  ViewController.swift
//  FYBannerView
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var banner:FYBannerView!
    var current:Int = 0
    var pageControl:UIPageControl!
    var flag:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let controlStyle = FYControlStyle()
////        
////        control = FYBannerControl()
////        control.frame.origin = CGPoint(x:100, y:50)
////        control.backgroundColor = UIColor.red
////        control.controlStyle = controlStyle
////        control.numberOfPages = 7
////        control.currentPage = 1
////        view.addSubview(control)
////        view.backgroundColor = UIColor.black
        
        
        btn1()
        btn2()
        
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x:0, y:150, width:200, height:30)
        pageControl.numberOfPages =  5
        pageControl.currentPageIndicatorTintColor = UIColor.yellow
        pageControl.pageIndicatorTintColor = UIColor.red
        view.addSubview(pageControl)
        
    }
    
    
    
    func btn1(){
        let btn = UIButton(type:.custom)
        btn.center = view.center
        btn.frame.size = CGSize(width:100, height:44)
        btn.backgroundColor = UIColor.gray
        btn.setTitle("点击", for: .normal)
        btn.addTarget(self, action: #selector(btnDidTapped), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    func btn2(){
        let btn = UIButton(type:.custom)
        btn.center = CGPoint(x:200, y:200)
        btn.frame.size = CGSize(width:100, height:44)
        btn.backgroundColor = UIColor.gray
        btn.setTitle("点击dd", for: .normal)
        btn.addTarget(self, action: #selector(btnDidTapped1), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    func btnDidTapped(){
        
        navigationController?.pushViewController(FirstViewController(), animated: true)
        
//        print(flag)
//        
//        pageControl.currentPage = flag
//        
//        flag += 1
//        
//        if pageControl.numberOfPages < flag {
//            flag = 0
//        }
        
        
    }
    
    func btnDidTapped1(){

        pageControl.numberOfPages = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

