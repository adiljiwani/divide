//
//  GroupIconCell.swift
//  divide
//
//  Created by Adil Jiwani on 2018-01-24.
//  Copyright © 2018 Adil Jiwani. All rights reserved.
//

import UIKit

class GroupIconCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    func configureCell (image: UIImage) {
        icon.image = image
    }
}
