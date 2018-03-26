//
//  ViewController.swift
//  led
//
//  Created by 科技部iOS on 2018/3/23.
//  Copyright © 2018年 Ken. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let KScreenWidth = UIScreen.main.bounds.size.width
    let KScreenHeight = UIScreen.main.bounds.size.height
    
    let SafeTopHeight = UIScreen.main.bounds.size.height == 812 ? 88 : 64
    let SafeBottomHeight = UIScreen.main.bounds.size.height == 812 ? 34 : 0
    
    var rectW : CGFloat = 5
    var lineW : CGFloat = 0.5
    var lineColor : UIColor = UIColor.black

    var sectionCount = 0
    var rowCount = 0
    
    var colorArr = [[UIColor]]()
    var ledView : LedView?

    var textF : UITextField?
    var rectTextF : UITextField?
    
    var photoBtn : UIButton?
    
    var imagePicker : UIImagePickerController?
    
    var selectImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sectionCount = Int(KScreenWidth/(lineW + rectW))
        rowCount = Int(KScreenWidth/(lineW + rectW))
        
        
        ledView = LedView.initView(frame: CGRect.init(x: 0, y: SafeTopHeight, width: Int(KScreenWidth), height: Int(KScreenWidth)), lineW: lineW, pixelW: rectW)
        self.view.addSubview(ledView!)
        
        
        textF = UITextField.init(frame: CGRect.init(x: 15, y: Int(ledView!.frame.maxY + 10), width: Int(KScreenWidth - 30) , height: 40))
        textF!.clearButtonMode = .always
        textF!.delegate = self
        textF!.placeholder = "要显示的文字"
        textF!.borderStyle = .roundedRect
        self.view.addSubview(textF!)
        
        photoBtn = UIButton.init(type: .roundedRect)
        photoBtn!.frame = CGRect.init(x: 15, y: textF!.frame.maxY + 10, width: 100, height: 100)
        photoBtn!.setBackgroundImage(#imageLiteral(resourceName: "add"), for: .normal)
        photoBtn!.addTarget(self, action: #selector(openPhotoLibrary(btn:)), for: .touchUpInside)
        self.view.addSubview(photoBtn!)
        
        rectTextF = UITextField.init(frame: CGRect.init(x: KScreenWidth/2.0, y: textF!.frame.maxY + 10, width: KScreenWidth/2.0 - 15, height: 40))
        rectTextF!.clearButtonMode = .always
        rectTextF!.delegate = self
        rectTextF!.placeholder = "格子宽高"
        rectTextF!.borderStyle = .roundedRect
        rectTextF?.keyboardType = .numbersAndPunctuation
        self.view.addSubview(rectTextF!)
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker!.sourceType = .photoLibrary
        self.imagePicker!.allowsEditing = true
        self.imagePicker?.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            return
        }
        if textField == self.textF {
            print("获取文字")
            print("文字转图片——开始")
            let image = StringToImg.image(with: textField.text!, font: UIFont.systemFont(ofSize: 60), width: KScreenWidth, textAlignment: .center)
            self.toChange(img: image!)
            self.selectImage = image;
        }else{
            if self.selectImage != nil {
                self.rectW = CGFloat(Int(textField.text!)!)
                self.ledView?.pixelW = self.rectW
                self.toChange(img: self.selectImage!)
            }
        }
    }
    
    func toChange(img:UIImage) {
        print("文字转图片——完成")
        let image = img.toSize(self.ledView!.frame.size)
        NSLog("图片大小改变——完成")
        self.colorArr.removeAll()
        
        let space = lineW+rectW
        
        //逐个逐个取  费时费资源
//        for section in 0..<sectionCount {
//
//            var arr = [UIColor]()
//            for row in 0..<rowCount {
//                let color = image?.color(atPixel: CGPoint.init(x: space * CGFloat(row) + space/2,
//                                                               y: space * CGFloat(section) + space/2))
//                if color != nil {
//                    arr.append(color!)
//                }else{
//                    arr.append(UIColor.black)
//                }
//            }
//            self.colorArr.append(arr)
//        }
        
        //速度快  但是总感觉效果没有逐个逐个取好
        self.colorArr = image?.color(atPixelPoints: space) as! [[UIColor]]
        NSLog("获取像素点Color——完成")
        
        ledView!.colorArr = self.colorArr
    }
    
    @objc func openPhotoLibrary(btn:UIButton) {
        self.present(self.imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.selectImage = image;
        self.toChange(img:  image)
        self.photoBtn?.setBackgroundImage(image, for: .normal)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

