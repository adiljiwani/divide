//
//  HomeVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-26.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var totalOwingLabel: UILabel!
    @IBOutlet weak var totalOwedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var owing: Float = 0.0
    var owed: Float = 0.0
    var transactionType = TransactionType.pending
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var transactionsArray = [Transaction]()
    var settledArray = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        self.segmentControl.layer.cornerRadius = 20
        self.segmentControl.layer.borderColor = #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)
        self.segmentControl.layer.borderWidth = 1
        self.segmentControl.layer.masksToBounds = true
        let font = UIFont(name: "AvenirNext-Regular", size: 15)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        if Auth.auth().currentUser != nil {
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
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            transactionType = .pending
            DataService.instance.getAllTransactions { (returnedTransactionArray) in
                self.transactionsArray = returnedTransactionArray
                self.tableView.reloadData()
                self.tableViewHeightConstraint.constant = min(CGFloat(self.transactionsArray.count) * self.tableView.rowHeight, self.view.frame.maxY - self.tableView.frame.minY)
            }
        } else {
            transactionType = .settled
            DataService.instance.getAllSettledTransactions(handler: { (settledTransactions) in
                self.settledArray = settledTransactions
                self.tableView.reloadData()
                self.tableViewHeightConstraint.constant = min(CGFloat(self.settledArray.count) * self.tableView.rowHeight, self.view.frame.maxY - self.tableView.frame.minY)
                
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if transactionType == .pending {
            numRows = transactionsArray.count
        } else {
            numRows = settledArray.count
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {return UITableViewCell()}
        var transaction : Transaction
        if transactionType == .pending {
            transaction = transactionsArray[indexPath.row]
        } else {
            transaction = settledArray[indexPath.row]
        }
    
            let owing = transaction.payees.contains((Auth.auth().currentUser?.email)!)
            let date = transaction.date
            let groupName = transaction.groupTitle
            var amount: Float = 0.0
            if owing {
                amount = transaction.amount / Float(transaction.payees.count + 1)
            } else {
                amount = Float(transaction.payees.count - (transaction.settled.count - 1)) * (transaction.amount / Float(transaction.payees.count + 1))
            }
            cell.configureCell(description: transaction.description, owing: owing, date: date, amount: Float(amount), groupName: groupName, type: transactionType)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let transactionVC = storyboard?.instantiateViewController(withIdentifier: "TransactionVC") as? TransactionVC else {return}
            transactionVC.initData(forTransaction: transactionsArray[indexPath.row], type: transactionType)
        presentDetail(transactionVC)
    }
    
}
