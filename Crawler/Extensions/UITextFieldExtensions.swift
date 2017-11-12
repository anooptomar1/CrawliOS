//
//  UITextFieldExtensions.swift
//  UnreelTester
//
//  Created by Jack Chorley on 06/11/2017.
//  Copyright © 2017 iZolo Ltd. All rights reserved.
//

import UIKit

extension UITextField {
    func correctedPlaceholderColor(color: UIColor) {
        
        let attString = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: color])
        
        self.attributedPlaceholder = attString
    }
}
