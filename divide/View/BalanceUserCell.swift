//
//  BalanceUserCell.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-05.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class BalanceUserCell: UITableViewCell {

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var paidLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell (email: String, paid: Bool, amount: Float) {
        userEmailLbl.text = email
        if paid {
            self.paidLbl.text = "PAID"
        } else {
            self.paidLbl.text = "OWES"
        }
        amountLbl.text = String(format: "$%.2f", amount)
    }

}
