//
//  ZHGestureUnlock.swift
//  手势解锁
//
//  Created by user on 16/2/14.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit
let btnCount = 9
let btnW: CGFloat = 74
let btnH: CGFloat = btnW
let colCount: Int = 3




class ZHGestureUnlockView: UIView {
  private var lineBtns: [ZHGesturePointBtn] = [ZHGesturePointBtn]()
  private var currentPoint: CGPoint?
  
  private var pwdIsCorrect:Bool = true
  
  /// 需要注意的是不要讲下面这两个闭包写在同一个文件中
  // 匹配手势密码是否正确
  var matchGesturePasswordClosure: ((pwd: String) -> Bool)?
  
  // 该闭包用于设置密码
  var setGesturePasswordClosure: ((pwd: String) -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 这样声明可以声明动态的数组吗，下面这种声明
  private lazy var btns: [ZHGesturePointBtn] = {
    var buttons: [ZHGesturePointBtn] = [ZHGesturePointBtn]()
    for i in 0..<btnCount {
      let btn: ZHGesturePointBtn = self.addBtn()
      btn.tag = i
      print(i)
      buttons.append(btn)
    }
    return buttons
  }()
  private func addBtn() -> ZHGesturePointBtn {
    let btn: ZHGesturePointBtn = ZHGesturePointBtn()
    btn.userInteractionEnabled = false
    self.addSubview(btn)
    return btn
  }
}

extension ZHGestureUnlockView {
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    let touch: UITouch = touches.first!
    let currentPoint: CGPoint = touch.locationInView(touch.view)
    
    // 遍历所有的btn
    for i in 0..<self.btns.count {
      let btn: ZHGesturePointBtn = self.btns[i]
      if CGRectContainsPoint(btn.frame, currentPoint) {
        btn.modifyPointBtnState = .JoinState
        self.lineBtns.append(btn)
      }
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    let touch: UITouch = touches.first!
    let currentPoint: CGPoint = touch.locationInView(touch.view)
    self.currentPoint = currentPoint
    for i in 0..<self.btns.count {
      let btn: ZHGesturePointBtn = self.btns[i]
      if CGRectContainsPoint(btn.frame, currentPoint) {
        if !self.lineBtns.contains(btn) {
          btn.modifyPointBtnState = .JoinState
          self.lineBtns.append(btn)
          self.setNeedsDisplay()
        }
      }
    }
    self.setNeedsDisplay()
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    self.currentPoint = self.lineBtns.last?.center
    self.setNeedsDisplay()
    var pwd: String = ""
    for i in 0..<self.lineBtns.count {
      print(self.lineBtns.count)
      let btn: ZHGesturePointBtn = self.lineBtns[i]
      pwd = pwd + "\(btn.tag)"
    }
    
    // 设置手势的密码
    if self.setGesturePasswordClosure != nil {
      self.setGesturePasswordClosure!(pwd: pwd)
      self.clear()
      self.setNeedsDisplay()
      self.userInteractionEnabled = true
    }
    // 匹配手势密码
    if self.matchGesturePasswordClosure != nil {
      if self.matchGesturePasswordClosure!(pwd: pwd) {
        // 密码匹配成功
        print("ddd")
      }
      else {
        pwdIsCorrect = false
        // 密码匹配失败
        for (_, btn) in self.lineBtns.enumerate() {
          btn.modifyPointBtnState = .ErrorState
        }
        self.userInteractionEnabled = false
        let alert: UIAlertController = UIAlertController(title: nil, message: "密码错误", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
              self.clear()
              self.setNeedsDisplay()
              self.userInteractionEnabled = true
            }))
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
      }
    }
  }
  
  // 恢复按钮初始化状态
  private func clear() {
    
    for i in 0..<self.btns.count {
      pwdIsCorrect = true
      self.btns[i].modifyPointBtnState = .NormalState
    }
    self.lineBtns.removeAll()
  }
  
  // 九宫格布局
  override func layoutSubviews() {
    
    super.layoutSubviews()
    let margin: CGFloat = (self.frame.width - 120) / 2
    
    for i in 0..<self.btns.count {
      
      let btnCenterX: CGFloat = (CGFloat(i) % CGFloat(colCount)) * margin + 60
      let btnCenterY: CGFloat = CGFloat(i / colCount) * margin + 60
      self.btns[i].center = CGPointMake(btnCenterX, btnCenterY)
      self.btns[i].bounds.size = CGSizeMake(40, 40)
    }
  }
  
  // 画线
  override func drawRect(rect: CGRect) {
    
    let path: UIBezierPath = UIBezierPath()
    // 遍历需要画线的数组
    for i in 0..<self.lineBtns.count {
      let btn: ZHGesturePointBtn = self.lineBtns[i]
      if i == 0 {
        path.moveToPoint(btn.center)
      }
      else {
        if (self.lineBtns.contains(btn)) {
          path.addLineToPoint(btn.center)
        }
      }
    }
    if self.lineBtns.count != 0 {
      path.addLineToPoint(self.currentPoint!)
    }
    
    let lineColor:UIColor = pwdIsCorrect ? UIColor.blueColor() : UIColor.redColor()
    
    lineColor.set()
    path.lineWidth = 2.5
    path.lineCapStyle = .Round
    path.lineJoinStyle = .Round
    path.stroke()
  }
}
