//
//  HomeVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-26.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {


    @IBOutlet weak var totalOwingLabel: UILabel!
    @IBOutlet weak var totalOwedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var owing: Float = 0.0
    var owed: Float = 0.0
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var transactionsArray = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_TRANSACTIONS.observe(.value) { (snapshot) in
            DataService.instance.getAllTransactions { (returnedTransactionArray) in
                self.transactionsArray = returnedTransactionArray
                self.tableView.reloadData()
                self.tableViewHeightConstraint.constant = CGFloat(self.transactionsArray.count) * self.tableView.rowHeight
            }
        }
        DataService.instance.getOwed(userKey: (Auth.auth().currentUser?.uid)!) { (owed) in
            self.owed = owed
            self.totalOwedLabel.text = String(format: "$%.2f", owed)
        }
        DataService.instance.getOwing(userKey: (Auth.auth().currentUser?.uid)!) { (owing) in
            self.owing = owing
            self.totalOwingLabel.text = String(format: "$%.2f", owing)
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {return UITableViewCell()}
        let transaction = transactionsArray[indexPath.row]
        let owing = transaction.payees.contains((Auth.auth().currentUser?.email)!)
        let date = transaction.date
        var amount: Float = 0.0
        if owing {
            amount = transaction.amount / Float(transaction.payees.count + 1)
        } else {
            amount = Float(transaction.payees.count) * (transaction.amount / Float(transaction.payees.count + 1))
        }
        cell.configureCell(description: transaction.description, owing: owing, date: date, amount: Float(amount))
        return cell
    }
}
