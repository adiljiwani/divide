//
//  memberBalanceCell.swift
//  divide
//
//  Created by Adil Jiwani on 2018-01-26.
//  Copyright © 2018 Adil Jiwani. All rights reserved.
//

import UIKit

class MemberBalanceCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    @IBOutlet weak var owingView: RoundedView!
    @IBOutlet weak var amountLabel: UILabel!
    
    func configureCell (name: String, amount: Float, owing: Bool) {
        profileImage.image = UIImage(named: "defaultProfileImage.png")
        if owing {
            self.owingLabel.text = "YOU OWE:"
            self.owingView.backgroundColor = #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)
        } else {
            self.owingLabel.text = "YOU ARE OWED:"
            self.owingView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.6941176471, blue: 0.3137254902, alpha: 1)
        }
        amountLabel.text = String(format: "$%.2f", amount)
    }
}
