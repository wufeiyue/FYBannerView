//
//  ViewController.swift
//  FYSliderView
//
//  Created by 武飞跃 on 16/10/3.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import UIKit

protocol Networking {
    func sendRequest(closure:@escaping ([[String:String]])-> Void)
}

extension Networking {
    func sendRequest(closure:@escaping ([[String:String]])-> Void){
        let url = URL(string: "http://7xt77b.com1.z0.glb.clouddn.com/fysliderview_text.json")
        let request = URLRequest(url: url!)
        let rask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                do{
                    guard let Data = data else{
                        return
                    }
                    let dic = try JSONSerialization.jsonObject(with: Data, options: .mutableContainers)
                    if dic is [String:Any] {
                        let dict = dic as! [String:Any]
                        let dataSource = dict["data"] as! [[String:String]]
                        
                        closure(dataSource)
                    }
                    
                }catch{
                    print(error)
                }
            }
        }
        
        rask.resume()
        
    }
}

class ViewController: UIViewController,FYSliderViewCustomizable {

    var sliderView:FYSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "轮播图"
        
        initData()
        
        createView()
    }
    
    func initData(){
        
        sendRequest {[weak self] in
            
            guard self != nil else {return}
            
            self!.sliderView.dataSource = $0.map({ dic in
                return FYDataModel(url: dic["banner_picture_url"], title: dic["banner_title"])
            })
            
        }
        
    }
    
    func createView(){
        let rect = CGRect(x: 0, y: 64, width: view.bounds.size.width, height: 200)
        sliderView = FYSliderView(frame: rect, option: self)
        view.addSubview(sliderView)
    }

}

extension ViewController:Networking{}

