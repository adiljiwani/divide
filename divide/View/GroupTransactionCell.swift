//
//  GroupTransactionCell.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-05.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class GroupTransactionCell: UITableViewCell {

    @IBOutlet weak var owingView: RoundedView!
    @IBOutlet weak var amountLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var owingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(description: String, owing: Bool, date: String, amount: Float) {
        self.descriptionLbl.text = description
        self.dateLbl.text = date
        self.amountLbl.text = String(format: "$%.2f", amount)
        if owing {
            self.owingLabel.text = "YOU OWE:"
            self.owingView.backgroundColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
        } else {
            self.owingLabel.text = "YOU ARE OWED:"
            self.owingView.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.7411764706, blue: 0.3294117647, alpha: 1)
        }
    }

}
