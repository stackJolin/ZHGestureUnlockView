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
  private var lineBtns: [UIButton] = [UIButton]()
  private var currentPoint: CGPoint?
  
  /// 需要注意的是不要讲下面这两个闭包写在同一个文件中
  // 匹配手势密码是否正确
  var matchGesturePasswordClosure: ((pwd: String) -> Bool)?
  
  // 该闭包用于设置密码
  var setGesturePasswordClosure: ((pwd: String) -> ())?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.blackColor()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 这样声明可以声明动态的数组吗，下面这种声明
  private lazy var btns: [UIButton] = {
    var buttons: [UIButton] = [UIButton]()
    for i in 0..<btnCount {
      let btn: UIButton = self.addBtn()
      btn.tag = i
      print(i)
      buttons.append(btn)
    }
    return buttons
  }()
  private func addBtn() -> UIButton {
    let btn: UIButton = UIButton()
    btn.userInteractionEnabled = false
    btn.setBackgroundImage(UIImage(named: "gesture_node_normal"), forState: UIControlState.Normal)
    btn.setBackgroundImage(UIImage(named: "gesture_node_highlighted"), forState: UIControlState.Highlighted)
    btn.setBackgroundImage(UIImage(named: "gesture_node_error"), forState: UIControlState.Selected)
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
      let btn: UIButton = self.btns[i]
      if CGRectContainsPoint(btn.frame, currentPoint) {
        btn.highlighted = true
        self.lineBtns.append(btn)
      }
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    let touch: UITouch = touches.first!
    let currentPoint: CGPoint = touch.locationInView(touch.view)
    self.currentPoint = currentPoint
    for i in 0..<self.btns.count {
      let btn: UIButton = self.btns[i]
      if CGRectContainsPoint(btn.frame, currentPoint) {
        if !self.lineBtns.contains(btn) {
          btn.highlighted = true
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
      let btn: UIButton = self.lineBtns[i]
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
        // 密码匹配失败
        for (_, btn) in self.lineBtns.enumerate() {
          btn.highlighted = false
          btn.selected = true
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
      self.btns[i].selected = false
      self.btns[i].highlighted = false
    }
    self.lineBtns.removeAll()
  }
  
  // 九宫格布局
  override func layoutSubviews() {
    
    super.layoutSubviews()
    let margin: CGFloat = (self.frame.size.width - CGFloat(colCount) * btnW) * 0.25
    
    for i in 0..<self.btns.count {
      
      let btnX: CGFloat = (CGFloat(i) % CGFloat(colCount)) * (margin + btnW) + margin
      let btnY: CGFloat = CGFloat((i / colCount)) * (margin + btnW) + margin
      self.btns[i].frame = CGRectMake(btnX, btnY, btnW, btnH)
    }
  }
  
  // 画线
  override func drawRect(rect: CGRect) {
    
    let path: UIBezierPath = UIBezierPath()
    // 遍历需要画线的数组
    for i in 0..<self.lineBtns.count {
      let btn: UIButton = self.lineBtns[i]
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
    
    UIColor.whiteColor().set()
    path.lineWidth = 10
    path.lineCapStyle = .Round
    path.lineJoinStyle = .Round
    path.stroke()
  }
}
