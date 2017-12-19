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

    @IBOutlet weak var settledTableView: UITableView!
    
    @IBOutlet weak var transactionStatusLbl: UILabel!
    @IBOutlet weak var settledTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var totalOwingLabel: UILabel!
    @IBOutlet weak var totalOwedLabel: UILabel!

    @IBOutlet weak var pendingTableView: UITableView!
    var owing: Float = 0.0
    var owed: Float = 0.0
    var transactionType = TransactionType.pending
    
    @IBOutlet weak var pendingTableViewHeightConstraint: NSLayoutConstraint!
    
    var transactionsArray = [Transaction]()
    var settledArray = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pendingTableView.delegate = self
        pendingTableView.dataSource = self
        pendingTableView.reloadData()
        
        settledTableView.isHidden = true
        pendingTableView.isHidden = false
        settledTableView.delegate = self
        settledTableView.dataSource = self
        settledTableView.reloadData()
        self.settledTableViewHeightConstraint.constant = min(CGFloat(self.settledArray.count) * self.settledTableView.rowHeight, self.view.frame.maxY - self.settledTableView.frame.minY)
        self.pendingTableViewHeightConstraint.constant = min(CGFloat(self.transactionsArray.count) * self.pendingTableView.rowHeight, self.view.frame.maxY - self.pendingTableView.frame.minY)
        self.segmentControl.layer.cornerRadius = 20
        self.segmentControl.layer.borderColor = #colorLiteral(red: 0.0431372549, green: 0.1960784314, blue: 0.3490196078, alpha: 1)
        self.segmentControl.layer.borderWidth = 1
        self.segmentControl.layer.masksToBounds = true
        let font = UIFont(name: "AvenirNext-Regular", size: 15)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        self.transactionStatusLbl.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
        DataService.instance.getOwed(userKey: (Auth.auth().currentUser?.uid)!) { (owed) in
            self.owed = owed
            self.totalOwedLabel.text = String(format: "$%.2f", owed)
        }
        DataService.instance.getOwing(userKey: (Auth.auth().currentUser?.uid)!) { (owing) in
            self.owing = owing
            self.totalOwingLabel.text = String(format: "$%.2f", owing)
        }
            DataService.instance.getAllTransactions { (returnedTransactionArray) in
                self.transactionsArray = returnedTransactionArray
                if self.transactionsArray.count == 0 && self.segmentControl.titleForSegment(at: self.segmentControl.selectedSegmentIndex) == "Pending"{
                    self.transactionStatusLbl.text = "You have no pending transactions."
                    self.transactionStatusLbl.isHidden = false
                } else {
                    self.transactionStatusLbl.isHidden = true
                }
                self.pendingTableView.reloadData()
                self.pendingTableViewHeightConstraint.constant = min(CGFloat(self.transactionsArray.count) * self.pendingTableView.rowHeight, self.view.frame.maxY - self.pendingTableView.frame.minY)
            }
        }
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            transactionType = .pending
            if self.transactionsArray.count == 0 {
                self.transactionStatusLbl.text = "You have no pending transactions."
                self.transactionStatusLbl.isHidden = false
            } else {
                self.transactionStatusLbl.isHidden = true
            }
            settledTableView.isHidden = true
            pendingTableView.isHidden = false
            pendingTableView.reloadData()
            
        } else {
            transactionType = .settled
            pendingTableView.isHidden = true
            settledTableView.isHidden = false
            DataService.instance.getAllSettledTransactions{ (settledTransactions) in
                self.settledArray = settledTransactions
                if self.settledArray.count == 0 {
                    self.transactionStatusLbl.text = "You have no settled transactions."
                    self.transactionStatusLbl.isHidden = false
                } else {
                    self.transactionStatusLbl.isHidden = true
                }
                self.settledTableView.reloadData()
                self.settledTableViewHeightConstraint.constant = min(CGFloat(self.settledArray.count) * self.settledTableView.rowHeight, self.view.frame.maxY - self.settledTableView.frame.minY)
                
            }
            self.settledTableView.reloadData()
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if tableView == pendingTableView {
            numRows = transactionsArray.count
        } else {
            numRows = settledArray.count
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        var transaction : Transaction
        if tableView == pendingTableView {
            transaction = transactionsArray[indexPath.row]
        } else if tableView == settledTableView {
            transaction = settledArray[indexPath.row]
        } else {
            transaction = transactionsArray[indexPath.row]
        }
        let description = transaction.description
        let owing = transaction.payees.contains((Auth.auth().currentUser?.email)!)
        let date = transaction.date
        let groupName = transaction.groupTitle
        var amount: Float = 0.0
        if owing {
            amount = transaction.amount / Float(transaction.payees.count + 1)
        } else {
            amount = Float(transaction.payees.count - (transaction.settled.count - 1)) * (transaction.amount / Float(transaction.payees.count + 1))
        }
        if transactionType == .pending {
            guard let pendingCell = pendingTableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {return UITableViewCell()}
            pendingCell.configureCell(description: description, owing: owing, date: date, amount: Float(amount), groupName: groupName, type: transactionType)
            cell = pendingCell
        } else if transactionType == .settled {
            guard let settledCell = settledTableView.dequeueReusableCell(withIdentifier: "settledCell") as? TransactionCell else {return UITableViewCell()}
            settledCell.configureCell(description: description, owing: owing, date: date, amount: Float(amount), groupName: groupName, type: transactionType)
            cell = settledCell
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let transactionVC = storyboard?.instantiateViewController(withIdentifier: "TransactionVC") as? TransactionVC else {return}
        if tableView == pendingTableView {
            transactionVC.initData(forTransaction: transactionsArray[indexPath.row], type: .pending)
        } else if tableView == settledTableView {
            transactionVC.initData(forTransaction: settledArray[indexPath.row], type: .settled)
        }
        
        presentDetail(transactionVC)
    }
    
}
