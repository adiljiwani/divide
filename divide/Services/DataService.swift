//
//  DataService.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-25.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_TRANSACTIONS = DB_BASE.child("transactions")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_TRANSACTIONS: DatabaseReference {
        return _REF_TRANSACTIONS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getEmail (forSearchQuery query: String, handler: @escaping (_ email: String) -> ()) {
        var matchEmail: String = ""
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                if userEmail == query && userEmail != Auth.auth().currentUser?.email {
                    matchEmail = userEmail
                    handler(matchEmail)
                }
            }
        }
    }
    
    func getName (handler: @escaping (_ name: String) -> ()) {
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let userName = user.childSnapshot(forPath: "name").value as! String
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                if userEmail == Auth.auth().currentUser?.email {
                    handler(userName)
                }
            }
        }
    }
    
    func getName (forEmail email: String, handler: @escaping (_ name: String) -> ()) {
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let userName = user.childSnapshot(forPath: "name").value as! String
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                if userEmail == email {
                    handler(userName)
                }
            }
        }
    }
    
    func getEmails (group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getNames (group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var nameArray = [String]()
        nameArray.append("You")
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if group.members.contains(user.key) && user.key != Auth.auth().currentUser?.uid{
                    let name = user.childSnapshot(forPath: "name").value as! String
                    nameArray.append(name)
                }
            }
            handler(nameArray)
        }
    }
    
    func getGroupNames (forSearchQuery query: String, handler: @escaping (_ groupNames: [String]) -> ()) {
        var groupNames = [String]()
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("groups").observe(.value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapshot {
                let groupName = group.childSnapshot(forPath: "title").value as! String
                let lowercasedName = groupName.lowercased()
                if lowercasedName.hasPrefix(query.lowercased()) {
                    groupNames.append(groupName)
                }
            }
            handler(groupNames)
        }
    }
    
    func getGroupMemberIds (forGroup groupName: String, handler: @escaping (_ groupMembers: [String]) -> ()) {
        var groupMemberIdsArray = [String]()
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("groups").observe(.value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapshot {
                let groupTitle = group.childSnapshot(forPath: "title").value as! String
                let groupMemberIds = group.childSnapshot(forPath: "members").value as! [String]
                if groupTitle == groupName {
                    groupMemberIdsArray = groupMemberIds
                    
                }
            }
            handler(groupMemberIdsArray)
        }
    }
    
    func getUsername(forUid uid: String, handler: @escaping(_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if user.key == uid {
                    handler(email)
                }
            }
        }
    }
    
    func getIds(forEmails emails: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                if emails.contains(userEmail) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func createGroup (withTitle title: String, ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        let groupRef = REF_GROUPS.childByAutoId()
        groupRef.updateChildValues(["title": title, "members": ids])
        for userId in ids {
            REF_USERS.child(userId).child("groups").child(groupRef.key).updateChildValues(["title": title, "members": ids])
        }
        handler(true)
    }
    
    func createTransaction(groupTitle: String, description: String, payees: [String], payer: String, date: String, amount: Float, settled: [String], handler: @escaping (_ transactionCreated: Bool) -> ()) {
        let transactionsRef = REF_TRANSACTIONS.childByAutoId()
        transactionsRef.updateChildValues(["description": description, "groupTitle": groupTitle, "payees": payees, "payer": payer, "date": date, "amount": amount, "settled": [payer]])
            getIds(forEmails: payees, handler: { (payeeIds) in
                for payeeId in payeeIds {
                    self.REF_USERS.observeSingleEvent(of: .value, with: { (userSnapshot) in
                        guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                        for user in userSnapshot {
                            if payeeId == user.key {
                                let owingValue = (user.childSnapshot(forPath: "owing").value as! NSString).floatValue + amount / Float(payees.count + 1)
                                self.REF_USERS.child(payeeId).updateChildValues(["owing": String(format: "%.2f", owingValue)])
                            
                            }
                        }
                    })
                }
            })
        getIds(forEmails: [payer], handler: { (userIds) in
            for userId in userIds {
                self.REF_USERS.observeSingleEvent(of: .value, with: { (userSnapshot) in
                    guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    for user in userSnapshot {
                        if user.key == userId {
                            let owedValue = (user.childSnapshot(forPath: "owed").value as! NSString).floatValue + Float(payees.count) * (amount / Float(payees.count + 1))
                            self.REF_USERS.child(userId).updateChildValues(["owed": String(format: "%.2f", owedValue)])
                        }
                    }
                })
            }
        })
        handler(true)
    }
    
    func settleTransaction (transaction: Transaction, handler: @escaping (_ transactionSettled:Bool) -> ()) {
        var settled  = transaction.settled
        settled.append((Auth.auth().currentUser?.email)!)
        REF_TRANSACTIONS.child(transaction.key).updateChildValues(["settled": settled])
        getIds(forEmails: [(Auth.auth().currentUser?.email)!], handler: { (payeeIds) in
            for payeeId in payeeIds {
                self.REF_USERS.observeSingleEvent(of: .value, with: { (userSnapshot) in
                    guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    for user in userSnapshot {
                        if payeeId == user.key {
                            let owingValue = (user.childSnapshot(forPath: "owing").value as! NSString).floatValue - (transaction.amount / Float(transaction.payees.count + 1))
                            self.REF_USERS.child(payeeId).updateChildValues(["owing": String(format: "%.2f", owingValue)])
                            
                        }
                    }
                })
            }
        })
        getIds(forEmails: [transaction.payer], handler: { (userIds) in
            for userId in userIds {
                self.REF_USERS.observeSingleEvent(of: .value, with: { (userSnapshot) in
                    guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                    for user in userSnapshot {
                        if user.key == userId {
                            let owedValue = (user.childSnapshot(forPath: "owed").value as! NSString).floatValue - (transaction.amount / Float(transaction.payees.count + 1))
                            print(owedValue)
                            self.REF_USERS.child(userId).updateChildValues(["owed": String(format: "%.2f", owedValue)])
                        }
                    }
                })
            }
        })
        handler(true)
    }
    
    func getOwing (userKey: String, handler: @escaping (_ owingAmount: Float) -> ()) {
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if user.key == userKey {
                    handler((user.childSnapshot(forPath: "owing").value as! NSString).floatValue)
                }
            }
        }
    }
    
    func getOwed (userKey: String, handler: @escaping (_ owedAmount: Float) -> ()) {
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if user.key == userKey{
                    handler((user.childSnapshot(forPath: "owed").value as! NSString).floatValue)
                }
            }
        }
    }
    
    func getAllTransactions (handler: @escaping (_ transactionArray: [Transaction]) -> ()) {
        var transactionArray = [Transaction]()
        
        REF_TRANSACTIONS.observeSingleEvent(of: .value) { (transactionSnapshot) in
            guard let transactionSnapshot = transactionSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for transaction in transactionSnapshot {
                let payer = transaction.childSnapshot(forPath: "payer").value as! String
                let payees = transaction.childSnapshot(forPath: "payees").value as! [String]
                let settled = transaction.childSnapshot(forPath: "settled").value as! [String]
                if Auth.auth().currentUser != nil {
                if payer == (Auth.auth().currentUser?.email)! || payees.contains((Auth.auth().currentUser?.email)!){
                    if (payer == (Auth.auth().currentUser?.email)! && (settled.count - 1) != payees.count) || !settled.contains((Auth.auth().currentUser?.email)!) {
                        let groupName = transaction.childSnapshot(forPath: "groupTitle").value as! String
                        let date = transaction.childSnapshot(forPath: "date").value as! String
                        let description = transaction.childSnapshot(forPath: "description").value as! String
                        let amount = transaction.childSnapshot(forPath: "amount").value as! Float
                    
                        let transactionFound = Transaction(groupTitle: groupName, key: transaction.key, payees: payees, payer: payer, date: date, description: description, amount: amount, settled: settled)
                        transactionArray.append(transactionFound)
                        }
                    }
                }
            }
            handler(transactionArray)
        }
    }
    
    func getAllTransactions (forGroup group: Group, handler: @escaping (_ transactionArray: [Transaction]) -> ()) {
        var groupTransactionArray = [Transaction]()
        REF_TRANSACTIONS.observeSingleEvent(of: .value) { (transactionSnapshot) in
            guard let transactionSnapshot = transactionSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for transaction in transactionSnapshot {
                let payer = transaction.childSnapshot(forPath: "payer").value as! String
                let payees = transaction.childSnapshot(forPath: "payees").value as! [String]
                let settled = transaction.childSnapshot(forPath: "settled").value as! [String]
                if Auth.auth().currentUser != nil {
                    if (payer == (Auth.auth().currentUser?.email)! && (settled.count - 1) != payees.count) || !settled.contains((Auth.auth().currentUser?.email)!) {
                            let groupName = transaction.childSnapshot(forPath: "groupTitle").value as! String
                            let date = transaction.childSnapshot(forPath: "date").value as! String
                            let description = transaction.childSnapshot(forPath: "description").value as! String
                            let amount = transaction.childSnapshot(forPath: "amount").value as! Float
                            if groupName == group.groupTitle {
                            let transactionFound = Transaction(groupTitle: groupName, key: transaction.key, payees: payees, payer: payer, date: date, description: description, amount: amount, settled: settled)
                            groupTransactionArray.append(transactionFound)
                        }
                    }
                }
            }
            handler(groupTransactionArray)
        }
    }
    
    func getAllGroups (handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("groups").observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapshot {
                let title = group.childSnapshot(forPath: "title").value as! String
                let groupMembers = group.childSnapshot(forPath: "members").value as! [String]
                let groupFound = Group(title: title, key: group.key, members: groupMembers, memberCount: groupMembers.count)
                groupsArray.append(groupFound)
            }
            handler(groupsArray)
        }
    }
}
