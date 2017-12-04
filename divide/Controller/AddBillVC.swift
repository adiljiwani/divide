//
//  AddBillVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-03.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AddBillVC: UIViewController {

    @IBOutlet weak var groupField: InsetTextField!
    @IBOutlet weak var billDescriptionField: InsetTextField!
    @IBOutlet weak var amountField: InsetTextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if billDescriptionField.text != "" && amountField.text != "" {
            
        }
    }
    
    
}
