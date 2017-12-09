//
//  SearchUserCell.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-04.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var friendEmailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (email: String, sender: String) {
        if sender == "transaction"{
        self.userEmailLbl.text = email
        } else {
            self.friendEmailLbl.text = email
        }
    }

}
