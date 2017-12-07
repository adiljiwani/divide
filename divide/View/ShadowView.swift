//
//  ShadowView.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-07.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }
}

