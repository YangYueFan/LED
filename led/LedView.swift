//
//  LedView.swift
//  led
//
//  Created by 科技部iOS on 2018/3/23.
//  Copyright © 2018年 Ken. All rights reserved.
//

import UIKit

class LedView: UIView {

    var lineW : CGFloat = 0;
    var pixelW : CGFloat = 0;
    
    var colorArr = [[UIColor]](){
        didSet{
            //开始重新绘制
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //获取画笔上下文
        let context:CGContext =  UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true) //抗锯齿设置
        
        let sectionCount = Int(frame.size.width/(lineW + pixelW))
        let rowCount = Int(frame.size.width/(lineW + pixelW))
        
        print("开始绘制")
        for section in 0..<sectionCount {
            for row in 0..<rowCount {
                //绘制矩形
                if self.colorArr.count == 0 {
                    context.setFillColor(UIColor.black.cgColor)
                }else{
                    context.setFillColor(self.colorArr[section][row].cgColor)
                }
                context.setStrokeColor( UIColor.gray.cgColor );
                context.addRect(CGRect(x: CGFloat(row)*(lineW + pixelW) ,
                                       y: CGFloat(section)*(lineW + pixelW),
                                       width: pixelW,
                                       height: pixelW ))
                context.fillPath()
                context.strokePath()
                
            }
        }
        print("开始绘制--完成")
    }
 
    static func initView(frame: CGRect,lineW:CGFloat,pixelW:CGFloat) -> LedView{
        let view = LedView.init(frame: frame)
        view.lineW = lineW
        view.pixelW = pixelW
        
        return view
    }

}
