//
//  NetManager.swift
//  DXRacer_Store
//
//  Created by 吕书涛 on 2018/8/22.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

import UIKit

class NetManager: NSObject {
    
    class func URLNSString(string:String) -> String {
        return "http://10.0.0.79:8080/mall/app/\(string)" as String
    }
    class func IMGURLNSString(string:String) -> String {
        return "http://10.0.0.79:8080/mall/app/\(string)" as String
    }
    
}
