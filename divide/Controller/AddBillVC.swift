//
//  AddBillVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-03.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AddBillVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var groupField: InsetTextField!
    @IBOutlet weak var billDescriptionField: InsetTextField!
    @IBOutlet weak var amountField: InsetTextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var paidByField: InsetTextField!
    @IBOutlet weak var groupsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var payerTableViewHeightConstraint: NSLayoutConstraint!
    
    var groupArray = [String]()
    var payer: String = ""
    var payerArray = [String]()
    var chosenGroup: String = ""
    var date = Date()
    
    func initData (date: Date, amount: Float) {
        self.date = date
        print(String(describing:amount))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupField.delegate = self
        groupField.addTarget(self, action: #selector(groupTextFieldDidChange), for: .editingChanged)
        groupsTableView.isHidden = true
        groupsTableView.layer.cornerRadius = 20
        groupsTableView.layer.masksToBounds = true
        groupsTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        groupsTableView.layer.borderWidth = 3.0
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        paidByField.delegate = self
        paidByField.addTarget(self, action: #selector(payerFieldTapped), for: .touchDown)
        usersTableView.isHidden = true
        usersTableView.layer.cornerRadius = 20
        usersTableView.layer.masksToBounds = true
        usersTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        usersTableView.layer.borderWidth = 1.0
    }
    
    @objc func payerFieldTapped () {
            self.usersTableView.isHidden = false
            DataService.instance.getGroupMemberIds(forGroup: groupField.text!, handler: { (groupMemberIds) in
                for id in groupMemberIds {
                    DataService.instance.getUsername(forUid: id, handler: { (email) in
                        if self.payerArray.count != groupMemberIds.count {
                            self.payerArray.append(email)
                            self.usersTableView.reloadData()
                            self.payerTableViewHeightConstraint.constant = CGFloat(self.payerArray.count * 40)
                        }
                    })
                }
            })
    }
    
    @objc func groupTextFieldDidChange () {
        if groupField.text == "" {
            self.groupsTableView.isHidden = true
            groupArray = []
            groupsTableView.reloadData()
        } else {
            self.groupsTableView.isHidden = false
            DataService.instance.getGroupNames(forSearchQuery: groupField.text!, handler: { (groupNameArray) in
                self.groupArray = groupNameArray
                self.groupsTableViewHeightConstraint.constant = CGFloat(self.groupArray.count * 40)
                self.groupsTableView.reloadData()
            })
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let result = formatter.string(from: date)
        let payeesArray = payerArray.filter({ $0 != payer })
        if billDescriptionField.text != "" && amountField.text != "" && groupField.text != "" && paidByField.text != "" {
            DataService.instance.createTransaction(groupTitle: groupField.text!, description: billDescriptionField.text!, payees: payeesArray, payer: paidByField.text!, date: result, amount: Float(amountField.text!)!, settled: payeesArray, handler: { (transactionCreated) in
                if transactionCreated {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Transaction could not be created")
                }
            })
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        if tableView == groupsTableView {
            numberOfRows = groupArray.count
        } else if tableView == usersTableView {
            numberOfRows = payerArray.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        if tableView == groupsTableView {
            guard let groupCell = tableView.dequeueReusableCell(withIdentifier: "searchGroupCell") as? SearchGroupCell else {return UITableViewCell()}
            groupCell.configureCell(groupName: groupArray[indexPath.row])
            cell = groupCell
        } else if tableView == usersTableView {
            guard let userCell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserCell else {return UITableViewCell()}
            userCell.configureCell(email: payerArray[indexPath.row])
            cell = userCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == groupsTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchGroupCell else {return}
            chosenGroup = cell.groupNameLbl.text!
            self.groupField.text = chosenGroup
            self.groupsTableView.isHidden = true
        } else if tableView == usersTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserCell else {return}
            payer = cell.userEmailLbl.text!
            self.paidByField.text = payer
            self.usersTableView.isHidden = true
        }
    }
}



extension AddBillVC: UITextFieldDelegate {
    
}
