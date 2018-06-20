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
        setupView()
        super.awakeFromNib()
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
    
    func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!)
        
        self.attributedPlaceholder = placeholder
    }
    
}
