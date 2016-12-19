//
//  Base2VC.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/11.
//  Copyright © 2016年 武飞跃. All rights reserved.
//

import UIKit

class Base2VC: UIViewController {
    
    //显示label 详情见SevenViewController
    lazy var showLabel:UILabel = {[unowned self] in
        $0.frame.size = CGSize(width: 100, height: 40)
        $0.center = self.view.center
        $0.textColor = UIColor.whiteColor()
        $0.backgroundColor = UIColor.grayColor()
        $0.font = UIFont.systemFontOfSize(18)
        $0.textAlignment = .Center
        $0.text = "显示值"
        return $0
        }(UILabel())
    
    var textString:String!{
        willSet{
            showLabel.text = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    ///获取数据
    func getData(completion:(data:NSData)->Void){
        let url = NSURL(string: "http://7xt77b.com1.z0.glb.clouddn.com/fysliderview_text.json")
        let request = NSURLRequest.init(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(data: data!)
            })
        }
        task.resume()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

