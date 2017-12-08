//
//  RoundedShadowView.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-07.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedShadowView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 7.0 {
        didSet {
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView () {
        self.layer.cornerRadius = self.bounds.height / 2
    }
}

