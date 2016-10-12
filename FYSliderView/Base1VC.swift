//
//  Base1VC.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/11.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class Base1VC: UIViewController {
    
    var showLabel:UILabel!
    var textString:String!{
        willSet{
            showLabel.text = newValue
        }
    }
    
    var networkData:NSData!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    func initData(){
        let url = NSURL(string: "http://7xt77b.com1.z0.glb.clouddn.com/fysliderview_notext.json")
        let request = NSURLRequest.init(URL: url!)
        let httpRequest = NSURLConnection.init(request: request, delegate: self)
        httpRequest?.start()
        
    }
    
    //显示label 详情见SevenViewController
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

extension Base1VC:NSURLConnectionDataDelegate{
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.networkData = NSData(data: data)
    }
    
    
}