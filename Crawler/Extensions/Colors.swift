//
//  Colors.swift
//  UnreelTester
//
//  Created by Jack Chorley on 17/10/2017.
//  Copyright © 2017 iZolo Ltd. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithRgb(_ r:Int, g:Int, b:Int) -> UIColor {
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
    }
    
    class func colorWithHsb(_ h:Int, s:Int, b:Int) -> UIColor {
        return UIColor(hue: CGFloat(h)/359, saturation: CGFloat(s)/100, brightness: CGFloat(b)/100, alpha: 1)
    }
    
    class func colorWithHsb(_ h:Int, s:Int, b:Int, a: CGFloat) -> UIColor {
        return UIColor(hue: CGFloat(h)/359, saturation: CGFloat(s)/100, brightness: CGFloat(b)/100, alpha: a)
    }
    
}

let shadowColor = UIColor.colorWithHsb(0, s: 0, b: 39, a: 0.5)
let shadowColorLight = UIColor.colorWithHsb(0, s: 0, b: 39, a: 0.3)
