//
//  ViewController.swift
//  ZHGestureUnlockView
//
//  Created by user on 16/2/18.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var pwd1:String? = "012"
  let gestureView:ZHGestureUnlockView = ZHGestureUnlockView(frame: CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(gestureView)
    
//    gestureView.setGesturePasswordClosure = {[weak self] (pwd: String) -> () in
//      if pwd != "" {
//        print("ddd")
//        self!.pwd1 = pwd
//        self!.getAlerController()
//      }
//    }
    gestureView.matchGesturePasswordClosure = { [weak self] (pwd:String) -> Bool in
      if pwd != "" {
        if self?.pwd1 == pwd {
          //self!.getAlerController()
          return true
        }
        else{
          return false
        }
      }
      else{
        return false
      }

    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func getAlerController() {
    
    let alert: UIAlertController = UIAlertController(title:nil, message: "请再次输入", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "确定", style: .Destructive, handler: { [weak self] (_) -> Void in
      // 访问网络获取手机验证码
      self!.gestureView.setGesturePasswordClosure = {[weak self] (pwd: String) -> () in
        print("eeee")
        if self!.pwd1 == pwd {
          //绘制成功：1.提示 2.通知切换根控制器
        }
      }
      }))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

