//
//  RoundedOutlineButton.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-25.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//
import UIKit
@IBDesignable
class RoundedOutlineButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 7.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = 5.0
            self.layer.borderColor = self.currentTitleColor.cgColor
        }
    }
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView () {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 5.0
        self.layer.borderColor = self.currentTitleColor.cgColor
    }
}
