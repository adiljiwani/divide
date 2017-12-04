//
//  TransactionCell.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-04.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var owingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(description: String, owing: Bool, date: String, amount: Float) {
        self.descriptionLabel.text = description
        self.dateLbl.text = date
        self.amountLbl.text = String(describing: amount)
        if owing {
            self.owingLbl.text = "YOU OWE:"
        } else {
            self.owingLbl.text = "YOU ARE OWED:"
        }
    }

}
