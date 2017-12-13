//
//  AddBillVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-03.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AddBillVC: UIViewController {
    

    @IBOutlet weak var billDescriptionField: InsetTextField!
    @IBOutlet weak var amountField: InsetTextField!
    @IBOutlet weak var paidByField: InsetTextField!
    @IBOutlet weak var dateField: InsetTextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var groupArray = [String]()
    var payer: String = ""
    var payerArray = [String]()
    var chosenGroup: String = ""
    var date: String?
    
    let picker = UIDatePicker()
    
    func initData (scannedDate: String, amount: Float) {
        self.date = scannedDate
        print(String(describing:amount))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.delegate = self
        amountField.addTarget(self, action: #selector(amountFieldChanged), for: .editingChanged)
        createDatePicker()
        if date != nil {
            dateField.text = date
        }
    }
    
    func createDatePicker () {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
        
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let result = formatter.string(from: picker.date)
        date = result
        dateField.text = "\(result)"
        self.view.endEditing(true)
    }
    
    @objc func amountFieldChanged () {
        amountField.text = amountField.text?.currencyInputFormatting()
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        guard let groupDetailsVC = storyboard?.instantiateViewController(withIdentifier: "GroupDetailsVC") as? GroupDetailsVC else {return}
        
        let amountFieldWithoutCurrency = amountField.text?.replacingOccurrences(of: "$", with: "")
        
        if billDescriptionField.text != "" && amountField.text != "" && dateField.text != "" {
            groupDetailsVC.initData(billDescription: billDescriptionField.text!, amount: Float(amountFieldWithoutCurrency!.replacingOccurrences(of: ",", with: ""))!, date: date!)
        presentDetail(groupDetailsVC)
        }
    }
  
}



extension AddBillVC: UITextFieldDelegate {
    
}
