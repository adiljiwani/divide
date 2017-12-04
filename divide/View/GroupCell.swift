//
//  GroupCell.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-04.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupType: UIImageView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var memberNumLbl: UILabel!
    
    func configureCell(groupName: String, memberCount: Int) {
        self.groupNameLbl.text = groupName
        self.memberNumLbl.text = "\(memberCount) members"
    }
}
