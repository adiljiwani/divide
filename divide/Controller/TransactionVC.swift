//
//  TransactionVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-05.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import Firebase

class TransactionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var transaction: Transaction?
    var emailArray = [String]()
    var amountArray = [Float]()


    func initData (forTransaction transaction: Transaction) {
        self.transaction = transaction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailArray.append((transaction?.payer)!)
        amountArray.append((transaction?.amount)!)
        if Auth.auth().currentUser?.email == transaction?.payer {
            for payee in (transaction?.payees)! {
                emailArray.append(payee)
                amountArray.append((transaction?.amount)! / (Float((transaction?.payees.count)!) + 1))
            }
        } else {
            emailArray.append((Auth.auth().currentUser?.email)!)
            amountArray.append((transaction?.amount)! / (Float((transaction?.payees.count)!) + 1))
        }
        
        self.tableViewHeightConstraint.constant = CGFloat(self.emailArray.count) * self.tableView.rowHeight
        descriptionLbl.text = transaction?.description
        groupNameLbl.text = transaction?.groupTitle
        dateLbl.text = transaction?.date
    }

    @IBAction func backPressed(_ sender: Any) {
        dismissDetail()
    }
}

extension TransactionVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "balanceUserCell") as? BalanceUserCell else {return UITableViewCell()}
        let email = emailArray[indexPath.row]
        let paid = transaction?.payer == email
        let amount = amountArray[indexPath.row]
        cell.configureCell(email: email, paid: paid, amount: amount)
        return cell
    }
}
