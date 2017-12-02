//
//  AddUserCell.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-29.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AddUserCell: UITableViewCell {

    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var deleteBtn: RoundedOutlineButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(email: String) {
        self.emailLbl.text = email
        self.layer.cornerRadius = self.bounds.height / 2
        self.deleteBtn.isHidden = false
    }
            
}
