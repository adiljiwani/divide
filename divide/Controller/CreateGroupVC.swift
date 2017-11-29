//
//  CreateGroupVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-27.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    @IBOutlet weak var groupNameField: InsetTextField!
    
    @IBOutlet weak var descriptionField: InsetTextField!
    
    @IBOutlet weak var membersField: InsetTextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIButton!
    

    @IBOutlet weak var addBtn: RoundedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addPressed(_ sender: Any) {
    }
    
    @IBAction func donePressed(_ sender: Any) {
    }
    
}
