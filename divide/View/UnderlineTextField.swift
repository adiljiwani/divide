//
//  UnderlineTextField.swift
//  divide
//
//  Created by Adil Jiwani on 2018-06-18.
//  Copyright © 2018 Adil Jiwani. All rights reserved.
//

import UIKit
import ReactiveKit
@IBDesignable
class UnderlineTextField: UITextField {
    private var padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UI.Colours.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.borderStyle = .line
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    
}
