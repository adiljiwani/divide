//
//  MemberBalanceCell.swift
//  divide
//
//  Created by Adil Jiwani on 2018-01-28.
//  Copyright © 2018 Adil Jiwani. All rights reserved.
//

import UIKit

class MemberBalanceCell: UICollectionViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    @IBOutlet weak var owingView: RoundedView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func configureCell (name: String, amount: Float, owing: Bool) {
        if owing {
            self.owingLabel.text = "YOU OWE"
        } else {
            
        }
    }
}
