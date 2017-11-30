//
//  RoundedOutlineTextView.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-29.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedOutlineTextView: UITextView {
    private var padding = UIEdgeInsets(top: 12.5, left: 20, bottom: 0, right: 0)
        @IBInspectable var cornerRadius: CGFloat = 7.0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
                self.layer.borderWidth = 1
                self.layer.borderColor = self.textColor?.cgColor
                self.textContainerInset = padding
            }
        }
}
