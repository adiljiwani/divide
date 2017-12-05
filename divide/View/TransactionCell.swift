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
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var owingView: RoundedView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(description: String, owing: Bool, date: String, amount: Float, groupName: String) {
        self.descriptionLabel.text = description
        self.dateLbl.text = date
        self.amountLbl.text = String(format: "$%.2f", amount)
        self.groupNameLbl.text = groupName
        if owing {
            self.owingLbl.text = "YOU OWE"
            self.owingView.backgroundColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
        } else {
            self.owingLbl.text = "YOU ARE OWED"
            self.owingView.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.7411764706, blue: 0.3294117647, alpha: 1)
        }
    }

}
