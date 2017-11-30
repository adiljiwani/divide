//
//  InsetTextField.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-25.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
@IBDesignable
class InsetTextField: UITextField {
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    @IBInspectable var cornerRadius: CGFloat = 7.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = 1
            self.layer.borderColor = self.textColor?.cgColor
        }
    }
    
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
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)])
        
        self.attributedPlaceholder = placeholder
    }
    
}
