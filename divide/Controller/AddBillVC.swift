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
    var amount: String?
    
    let picker = UIDatePicker()
    
    func initData (scannedDate: String, amount: String) {
        self.date = scannedDate
        self.amount = amount
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billDescriptionField.delegate = self
        billDescriptionField.addTarget(self, action: #selector(descFieldChanged), for: .editingChanged)
        dateField.delegate = self
        amountField.delegate = self
        amountField.addTarget(self, action: #selector(amountFieldChanged), for: .editingChanged)
        createDatePicker()
        if date != nil {
            dateField.text = date
        }
        if amount != nil {
            amountField.text = amount?.currencyInputFormatting()
        }
    }
    
    @objc func descFieldChanged () {
        if billDescriptionField.layer.borderColor == #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1) {
            billDescriptionField.layer.borderColor = #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)
            let placeholder = NSAttributedString(string: billDescriptionField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)])
            billDescriptionField.attributedPlaceholder = placeholder
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        billDescriptionField.becomeFirstResponder()
    }
    
    func createDatePicker () {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
        if date != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            picker.date = formatter.date(from: date!)!
        }
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        if dateField.layer.borderColor == #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1) {
            dateField.layer.borderColor = #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)
            let placeholder = NSAttributedString(string: dateField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)])
            dateField.attributedPlaceholder = placeholder
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let result = formatter.string(from: picker.date)
        date = result
        dateField.text = "\(result)"
        self.view.endEditing(true)
    }
    
    @objc func amountFieldChanged () {
        if amountField.layer.borderColor == #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1) {
            amountField.layer.borderColor = #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)
            let placeholder = NSAttributedString(string: amountField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)])
            amountField.attributedPlaceholder = placeholder
        }
        amountField.text = amountField.text?.currencyInputFormatting()
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        
        if (billDescriptionField.text == "") {
            billDescriptionField.layer.borderColor = #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)
            let placeholder = NSAttributedString(string: billDescriptionField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)])
            billDescriptionField.attributedPlaceholder = placeholder
        }
        
        if amountField.text == "" {
            amountField.layer.borderColor = #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)
            let placeholder = NSAttributedString(string: amountField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)])
            amountField.attributedPlaceholder = placeholder
        }
        
        if dateField.text == "" {
            dateField.layer.borderColor = #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)
            let placeholder = NSAttributedString(string: dateField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8078431373, green: 0.1137254902, blue: 0.007843137255, alpha: 1)])
            dateField.attributedPlaceholder = placeholder
        }
        
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
