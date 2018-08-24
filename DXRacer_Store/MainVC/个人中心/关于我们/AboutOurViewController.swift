//
//  AboutOurViewController.swift
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/8/22.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

import UIKit

class AboutOurViewController: UIViewController {
    let scrollview = UIScrollView()
    let textLab = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        scrollview.frame = CGRect(x: 5, y: 64, width: self.view.frame.size.width-10, height: self.view.frame.size.height-64)
        scrollview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(scrollview)
        
        textLab.text = "    迪瑞克斯座椅（江阴）有限公司成立于2015年，旗下品牌迪瑞克斯（DXRacer）是全球知名座椅领导品牌，以追求高品质生活和以人为本的设计理念，围绕着“人体工程学”这一专业领域，倡导健康、正确的计算机操作空间，寻求促进健康意识的计算机操作的创新解决方案。\n    迪瑞克斯（DXRacer）致力于为全球用户提供中高端电脑椅、办公椅以及人体工学等设备。其产品远销欧美40余个国家，在全球电竞圈与办公领域颇有盛名，有着电竞椅之王的美誉。\n    DXRacer目前已同步销售十多个电脑椅系列，每个系列拥有不同的设计元素，针对不同的用户群体。生产工艺日益创新，平均每季度会推出新款，更新升级经典款，凭借着追求品质和以人为本的设计理念，DXRacer座椅日渐深受各领域玩家的喜爱。\n    尤其在电竞领域，迪瑞克斯不仅成为WCG、LPL、IEM、StarsWar、ESL等世界各大电竞赛事的赞助商，还是SKT、NAVI、NIP、EDG等世界知名战队合作伙伴，为众多职业选手和电竞粉丝的首选装备。\n    一直以来，公司都倡导健康的生活环境，将不断创新并造就出更多提升人们生活品质的产品，也坚信迪瑞克斯（DXRacer）产品将走进许多人的生活，为更多的人造就健康的操作空间。"
        textLab.numberOfLines = 0
        Manager.changeLineSpace(for: textLab, withSpace: 8)
        let height = Manager.getLabelHeight(withContent: textLab.text, andLabelWidth: self.view.frame.size.width-20, andLabelFontSize: 21)
        print(height)
        textLab.frame = CGRect(x: 5, y: 0, width: self.view.frame.size.width-20, height: height)
        scrollview.addSubview(textLab)
        scrollview.contentSize = CGSize(width: 0, height: height)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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
