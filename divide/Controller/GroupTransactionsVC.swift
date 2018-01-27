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
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var membersTextView: UITextView!
    var group: Group?
    var groupTransactions = [Transaction]()
    var maxHeight: CGFloat = 0.0
    var groupMembers = [String]()
    var memberCount = 0
    
    func initData (forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        var hello = ["Name", true, 15] as [Any]
        print(hello[0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupNameLbl.text = group?.groupTitle
        DataService.instance.REF_GROUPS.child((group?.key)!).child("members").observe(.value) { (snapshot) in
            DataService.instance.getNames(forGroupKey: (self.group?.key)!, handler: { (returnedNames) in
                self.membersTextView.text = returnedNames.joined(separator: ", ")
                self.memberCount = returnedNames.count
            })
        }
        
        
        DataService.instance.getEmails(forGroupKey: (group?.key)!) { (returnedEmails) in
            self.groupMembers = returnedEmails
        }

        DataService.instance.getAllTransactions(forGroup: group!) { (returnedTransactions) in
            self.groupTransactions = returnedTransactions
            self.collectionView.reloadData()
        }
    }

    @IBAction func backPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        guard let editMembersVC = storyboard?.instantiateViewController(withIdentifier: "EditMembersVC") as? EditMembersVC else {return}
        editMembersVC.initData(group: group!)
        editMembersVC.modalPresentationStyle = .custom
        self.present(editMembersVC, animated: true, completion: nil)
    }
    
    @IBAction func removePressed(_ sender: Any) {
            if memberCount > 2 {
                guard let removeMembersVC = self.storyboard?.instantiateViewController(withIdentifier: "RemoveMembersVC") as? RemoveMembersVC else {return}
                removeMembersVC.initData(chosenGroup: self.group!)
                removeMembersVC.modalPresentationStyle = .custom
                self.present(removeMembersVC, animated: true, completion: nil)
            } else {
                let groupName = self.group?.groupTitle
                let alert = UIAlertController(title: "Remove members from \"\(groupName!)\"", message: "You cannot remove members from this group. There are only 2 people in this group.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let groupName = group?.groupTitle
        DataService.instance.getNumTransactions(inGroup: (group?.key)!) { (canDelete) in
            if canDelete {
                let deleteAlert = UIAlertController(title: "Delete \"\(groupName!)\"", message: "Are you sure you want to delete this group?", preferredStyle: .actionSheet)
                let deleteAction = UIAlertAction(title: "Delete group", style: .destructive, handler: { (buttonPressed) in
                    DataService.instance.deleteGroup(key: (self.group?.key)!, handler: { (groupDeleted) in
                        if groupDeleted {
                            self.dismissDetail()
                        }
                    })
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
                    deleteAlert.dismiss(animated: true, completion: nil)
                }
                deleteAlert.addAction(deleteAction)
                deleteAlert.addAction(cancelAction)
                self.present(deleteAlert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Delete \"\(groupName!)\"", message: "This group cannot be deleted. There are one or more pending transactions in this group.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
}

extension GroupTransactionsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberBalanceCell", for: indexPath) as? GroupIconCell else {return UICollectionViewCell()}
        return cell
    }
}

extension GroupTransactionsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * 8
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 4
        let heightPerItem = widthPerItem
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//extension GroupTransactionsVC: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return groupTransactions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupTransactionCell") as? GroupTransactionCell else {return UITableViewCell()}
//        let description = groupTransactions[indexPath.row].description
//        let owing = groupTransactions[indexPath.row].payees.contains((Auth.auth().currentUser?.email)!)
//        let date = groupTransactions[indexPath.row].date
//        var amount: Float = 0.0
//        if owing {
//            amount = groupTransactions[indexPath.row].amount / Float(groupTransactions[indexPath.row].payees.count + 1)
//        } else {
//            amount = Float(groupTransactions[indexPath.row].payees.count - (groupTransactions[indexPath.row].settled.count - 1)) * (groupTransactions[indexPath.row].amount / Float(groupTransactions[indexPath.row].payees.count + 1))
//        }
//        cell.configureCell(description: description, owing: owing, date: date, amount: amount)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let transactionVC = storyboard?.instantiateViewController(withIdentifier: "TransactionVC") as? TransactionVC else {return}
//        transactionVC.initData(forTransaction: groupTransactions[indexPath.row], type: TransactionType.pending)
//        presentDetail(transactionVC)
//    }
//}

