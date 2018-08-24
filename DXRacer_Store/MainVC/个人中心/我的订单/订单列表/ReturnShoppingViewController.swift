//
//  ReturnShoppingViewController.swift
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/8/22.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

import UIKit

class ReturnShoppingViewController: UIViewController,UITextViewDelegate {
    var orderNo = NSString()
    var textf = UITextView()
    var btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        
        
        btn = UIButton(type: .custom)
        let lab = UILabel()
        if let type = Manager.shared().iphoneType(), type == "iPhone X" {
            lab.frame = CGRect(x: 10, y: 93, width: self.view.frame.size.width-20, height: 30)
            textf.frame = CGRect(x: 10, y: 140, width: self.view.frame.size.width-20, height: 150)
            btn.frame = CGRect(x: 10, y: 310, width: self.view.frame.size.width-20, height: 50)
        }else{
            lab.frame = CGRect(x: 10, y: 69, width: self.view.frame.size.width-20, height: 30)
            textf.frame = CGRect(x: 10, y: 116, width: self.view.frame.size.width-20, height: 150)
            btn.frame = CGRect(x: 10, y: 286, width: self.view.frame.size.width-20, height: 50)
        }
        textf.layer.borderWidth = 1
        textf.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        textf.delegate = self
        textf.font = UIFont.systemFont(ofSize: 18)
        lab.text = "退货退款原因:"
        self.view.addSubview(lab)
        self.view.addSubview(textf)
        
//        if #available(iOS 10.0, *) {
//            button.backgroundColor = UIColor(displayP3Red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
//        } else {
//            button.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
//        }
        
        btn.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
        btn.setTitle("提交申请", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(clickCommit), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }

    @objc func clickCommit(){
        //print(textf.text!,orderNo)
        
        let pinjieStr = "refund/creare?orderNo=" + (orderNo as String) + "&remarks=" + textf.text
        let returnStr = NetManager.URLNSString(string: pinjieStr)
        
        let url = returnStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        //print(returnStr)
        
        Manager.requestPOST(withURLStr: url, paramDic: ["":""], token: nil, finish: { (response) in
            let dct = Manager.returndictiondata(response as! Data)
            let key_value = dct?[AnyHashable("code")] as! Int
            let value_value = dct?[AnyHashable("object")] as! String
            print(key_value,value_value)
            guard key_value == 200 else{
                return
            }
            let alert = UIAlertController.init(title: value_value, message: "温馨提示", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: {
            })
        }) { (error) in
            print(error ?? "")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReturnShoppingViewController{
    

}






















