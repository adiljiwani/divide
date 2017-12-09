//
//  GroupTransactionsVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-04.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import Firebase

class GroupTransactionsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var membersTextView: UITextView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var group: Group?
    var groupTransactions = [Transaction]()
    var maxHeight: CGFloat = 0.0
    
    func initData (forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupNameLbl.text = group?.groupTitle
        DataService.instance.getNames(group: group!) { (returnedNames) in
            self.membersTextView.text = returnedNames.joined(separator: ", ")
        }
        
        DataService.instance.getAllTransactions(forGroup: group!) { (returnedTransactions) in
            self.groupTransactions = returnedTransactions
            self.tableView.reloadData()
            self.tableViewHeightConstraint.constant = CGFloat(self.groupTransactions.count) * self.tableView.rowHeight
        }
    }

    @IBAction func backPressed(_ sender: Any) {
        dismissDetail()
    }
}

extension GroupTransactionsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupTransactionCell") as? GroupTransactionCell else {return UITableViewCell()}
        let description = groupTransactions[indexPath.row].description
        let owing = groupTransactions[indexPath.row].payees.contains((Auth.auth().currentUser?.email)!)
        let date = groupTransactions[indexPath.row].date
        var amount: Float = 0.0
        if owing {
            amount = groupTransactions[indexPath.row].amount / Float(groupTransactions[indexPath.row].payees.count + 1)
        } else {
            amount = Float(groupTransactions[indexPath.row].payees.count - (groupTransactions[indexPath.row].settled.count - 1)) * (groupTransactions[indexPath.row].amount / Float(groupTransactions[indexPath.row].payees.count + 1))
        }
        cell.configureCell(description: description, owing: owing, date: date, amount: amount)
        return cell
    }
}
