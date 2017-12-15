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
    
    @IBOutlet weak var chosenPayeeCell: UILabel!
    @IBOutlet weak var chosenUserEmailLbl: UILabel!
    
    
    @IBOutlet weak var removeMemberCell: UILabel!
    
    @IBOutlet weak var deleteBtn: RoundedOutlineButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(email: String, sender: String) {
        if sender == "group" {
        self.emailLbl.text = email
        self.deleteBtn.isHidden = false
        } else if sender == "addMember" {
            self.chosenUserEmailLbl.text = email
        } else if sender == "groupDetails" {
            self.chosenPayeeCell.text = email
        } else if sender == "removeMember" {
            self.removeMemberCell.text = email
        }
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func returnEmail() -> String {
        return self.emailLbl.text!
    }
            
}
