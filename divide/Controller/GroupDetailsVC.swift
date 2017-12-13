//
//  GroupDetailsVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-12.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class GroupDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var groupNameField: InsetTextField!
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    @IBOutlet weak var payerTableView: UITableView!
    
    @IBOutlet weak var chosenPayeesTableView: UITableView!
    
    @IBOutlet weak var payeeTableView: UITableView!
    
    @IBOutlet weak var chosenPayeeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var payeeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var payeeField: InsetTextField!
    @IBOutlet weak var payerField: InsetTextField!
    
    @IBOutlet weak var groupsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var payerTableViewHeightConstraint: NSLayoutConstraint!
    var groupArray = [String]()
    var payer: String = ""
    var payerArray = [String]()
    var payeeArray = [String]()
    var chosenUsers = [String]()
    var suggestedPayeeArray = [String]()
    var chosenGroup: String = ""
    var billDescription: String?
    var amount: Float?
    var date: String?
    
    func initData (billDescription: String, amount: Float, date: String) {
        self.billDescription = billDescription
        self.amount = amount
        self.date = date
        print(billDescription)
        print(amount)
        print(date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupNameField.delegate = self
        groupNameField.addTarget(self, action: #selector(groupTextFieldDidChange), for: .editingChanged)
        groupsTableView.isHidden = true
        groupsTableView.layer.cornerRadius = 20
        groupsTableView.layer.masksToBounds = true
        groupsTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        groupsTableView.layer.borderWidth = 3.0
        
        payerTableView.delegate = self
        payerTableView.dataSource = self
        payerField.delegate = self
        payerField.addTarget(self, action: #selector(payerFieldTapped), for: .touchDown)
        payerTableView.isHidden = true
        payerTableView.layer.cornerRadius = 20
        payerTableView.layer.masksToBounds = true
        payerTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        payerTableView.layer.borderWidth = 1.0
        
        payeeTableView.delegate = self
        payeeTableView.dataSource = self
        payeeField.delegate = self
        payeeField.addTarget(self, action: #selector(payeeFieldTapped), for: .touchDown)
        payeeTableView.isHidden = true
        payeeTableView.layer.cornerRadius = 20
        payeeTableView.layer.masksToBounds = true
        payeeTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        payeeTableView.layer.borderWidth = 1.0
        
        chosenPayeesTableView.delegate = self
        chosenPayeesTableView.dataSource = self
        self.chosenPayeeTableViewHeightConstraint.constant = CGFloat(self.payeeArray.count) * self.chosenPayeesTableView.rowHeight
        chosenPayeesTableView.isHidden = false
    }
    
    @objc func payerFieldTapped () {
        self.payerTableView.isHidden = false
        self.payeeTableView.isHidden = true
        payerArray = []
        DataService.instance.getGroupMemberIds(forGroup: groupNameField.text!, handler: { (groupMemberIds) in
            for id in groupMemberIds {
                DataService.instance.getUsername(forUid: id, handler: { (email) in
                    if !self.chosenUsers.contains(email){
                        self.payerArray.append(email)
                        self.payerTableView.reloadData()
                        self.payerTableViewHeightConstraint.constant = CGFloat(self.payerArray.count * 40)
                    }
                })
            }
        })
    }
    
    @objc func payeeFieldTapped () {
        self.payeeTableView.isHidden = false
        self.payerTableView.isHidden = true
        suggestedPayeeArray = []
        DataService.instance.getGroupMemberIds(forGroup: groupNameField.text!, handler: { (groupMemberIds) in
            for id in groupMemberIds {
                DataService.instance.getUsername(forUid: id, handler: { (email) in
                    if email != self.payer && !self.chosenUsers.contains(email){
                        self.suggestedPayeeArray.append(email)
                        self.payeeTableView.reloadData()
                        self.payeeTableViewHeightConstraint.constant = CGFloat(self.suggestedPayeeArray.count * 40)
                    }
                })
            }
        })
    }
    
    @objc func groupTextFieldDidChange () {
        if groupNameField.text == "" {
            self.groupsTableView.isHidden = true
            groupArray = []
            groupsTableView.reloadData()
        } else {
            self.groupsTableView.isHidden = false
            DataService.instance.getGroupNames(forSearchQuery: groupNameField.text!, handler: { (groupNameArray) in
                self.groupArray = groupNameArray
                self.groupsTableViewHeightConstraint.constant = CGFloat(self.groupArray.count * 40)
                self.groupsTableView.reloadData()
            })
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        let payeesArray = payerArray.filter({ $0 != payer })
        if groupNameField.text != "" && payerField.text != "" {
            DataService.instance.createTransaction(groupTitle: groupNameField.text!, description: billDescription!, payees: chosenUsers, payer: payerField.text!, date: date!, amount: amount!, settled: payeesArray, handler: { (transactionCreated) in
                if transactionCreated {
                    self.presentDetail(tabBar!)
                } else {
                    print("Transaction could not be created")
                }
            })
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetail()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        if tableView == groupsTableView {
            numberOfRows = groupArray.count
        } else if tableView == payerTableView {
            numberOfRows = payerArray.count
        } else if tableView == payeeTableView {
            numberOfRows = suggestedPayeeArray.count
        } else if tableView == chosenPayeesTableView {
            numberOfRows = chosenUsers.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        if tableView == groupsTableView {
            guard let groupCell = tableView.dequeueReusableCell(withIdentifier: "searchGroupCell") as? SearchGroupCell else {return UITableViewCell()}
            groupCell.configureCell(groupName: groupArray[indexPath.row])
            cell = groupCell
        } else if tableView == payerTableView {
            guard let userCell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserCell else {return UITableViewCell()}
            userCell.configureCell(email: payerArray[indexPath.row], sender: "transaction")
            cell = userCell
        } else if tableView == payeeTableView {
            guard let payeeCell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserCell else {return UITableViewCell()}
            payeeCell.configureCell(email: suggestedPayeeArray[indexPath.row], sender: "payee")
            cell = payeeCell
        } else if tableView == chosenPayeesTableView {
            guard let chosenPayeesCell = tableView.dequeueReusableCell(withIdentifier: "addUserCell") as? AddUserCell else {return UITableViewCell()}
            chosenPayeesCell.configureCell(email: chosenUsers[indexPath.row], sender: "groupDetails")
            cell = chosenPayeesCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == groupsTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchGroupCell else {return}
            chosenGroup = cell.groupNameLbl.text!
            self.groupNameField.text = chosenGroup
            self.groupsTableView.isHidden = true
        } else if tableView == payerTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserCell else {return}
            payer = cell.userEmailLbl.text!
            chosenUsers = []
            self.payerField.text = payer
            self.payerTableView.isHidden = true
        } else if tableView == payeeTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserCell else {return}
            if !chosenUsers.contains(cell.payeeEmailLbl.text!) {
                chosenUsers.append(cell.payeeEmailLbl.text!)
            }
            self.payeeTableView.isHidden = true
            self.chosenPayeesTableView.isHidden = false
            self.chosenPayeesTableView.reloadData()
            self.chosenPayeeTableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.chosenPayeesTableView.rowHeight
            self.payeeField.text = ""
        }
    }

}

extension GroupDetailsVC: UITextFieldDelegate {
    
}
