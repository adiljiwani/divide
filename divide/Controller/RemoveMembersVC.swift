//
//  RemoveMembersVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-15.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import Firebase
class RemoveMembersVC: UIViewController {

    var chosenUsers = [String]()
    var group: Group?
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var chosenUsersTableViewHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var chosenUsersTableView: UITableView!
    
    func initData (chosenGroup: Group) {
        self.group = chosenGroup
        DataService.instance.getEmails(group: chosenGroup) { (returnedEmails) in
            self.chosenUsers = returnedEmails.filter { $0 != Auth.auth().currentUser?.email }
            self.chosenUsersTableView.reloadData()
            self.chosenUsersTableViewHeightConstrain.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenUsersTableView.delegate = self
        chosenUsersTableView.dataSource = self
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(RemoveMembersVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let point = chosenUsersTableView.convert(CGPoint.zero, from: sender)
        if let indexPath = chosenUsersTableView.indexPathForRow(at: point) {
            DataService.instance.getIds(forEmails: [chosenUsers[indexPath.row]]) { (id) in
                DataService.instance.getAllTransactions(forGroup: self.group!, andUser: id[0], handler: { (transactions) in
                    if transactions.count == 0 {
                        if let groupName = self.group?.groupTitle {
                        let alert = UIAlertController(title: "Remove member from group", message: "Are you sure you want to remove \(self.chosenUsers[indexPath.row]) from \(groupName)?", preferredStyle: .alert)
                        
                        let removeAction = UIAlertAction(title: "Yes", style: .default) { (buttonPressed) in
                            DataService.instance.removeMember(fromGroup: (self.group?.key)!, currentMembers: (self.group?.members)!, memberToDelete: id[0], groupName: (self.group?.groupTitle)!) { (memberRemoved) in
                                
                            }
                            self.chosenUsers = self.chosenUsers.filter { $0 != self.chosenUsers[indexPath.row]}
                            self.chosenUsersTableView.reloadData()
                            self.chosenUsersTableViewHeightConstrain.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(removeAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RemoveMembersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addUserCell") as? AddUserCell else {return UITableViewCell()}
        let email = chosenUsers[indexPath.row]
        DataService.instance.getName(forEmail: email) { (name) in
            cell.configureCell(email: email, name: name, sender: "removeMember")
        }
        return cell
    }
}
