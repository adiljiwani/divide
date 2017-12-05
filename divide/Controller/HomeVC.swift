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
            }
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
        let amount = transaction.amount / Float(transaction.payees.count + 1)
        cell.configureCell(description: transaction.description, owing: owing, date: date, amount: Float(amount))
        return cell
    }
}
