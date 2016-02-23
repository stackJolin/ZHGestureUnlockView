//
//  ZHGesturePointBtn.swift
//  ZHGestureUnlockView
//
//  Created by user on 16/2/22.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit

enum ZHPointBtnState: Int {
  case NormalState = 0 // 黑色
  case JoinState = 1
  case ErrorState = 2 // 红色
}

class ZHGesturePointBtn: UIButton {
  
  var modifyPointBtnState: ZHPointBtnState = .NormalState {
    didSet {
      switch modifyPointBtnState {
      case .NormalState:
        self.inerView.backgroundColor = UIColor.blueColor()
      
      case .JoinState:
        self.inerView.layer.cornerRadius = 12.5
        UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.inerView.bounds = CGRectMake(0, 0, 25, 25)
          }, completion: { (_) -> Void in
            self.inerView.bounds = CGRectMake(0, 0, 11, 11)
            self.inerView.layer.cornerRadius = 5.5
          })
      
      case .ErrorState:
        self.inerView.backgroundColor = UIColor.redColor()
      }
    }
  }
  
  private lazy var inerView: UIView = {
    let tmpView: UIView = UIView()
    tmpView.center = CGPointMake(20, 20)
    tmpView.backgroundColor = UIColor.redColor()
    tmpView.bounds.size = CGSizeMake(11, 11)
    tmpView.layer.cornerRadius = 5.5
    tmpView.clipsToBounds = true
    tmpView.userInteractionEnabled = false
    return tmpView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
    self.addSubview(inerView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    print("增加了一个LOG")
    
    print("增加了第二个LOG")
    
    fatalError("init(coder:) has not been implemented")
  }
}
