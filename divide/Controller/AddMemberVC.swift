//
//  AddMemberVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-09.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AddMemberVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var doneBtn: RoundedButton!
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var membersTextField: InsetTextField!
    
    @IBOutlet weak var usersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chosenUsersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chosenUsersTableView: UITableView!
    
    var chosenUsers = [String]()
    var membersArray = [String]()
    var currentUsers = [String]()
    var group: Group?
    func initData (group: Group) {
        DataService.instance.getEmails(group: group) { (returnedEmails) in
            self.currentUsers = returnedEmails
            self.chosenUsers = returnedEmails
        }
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersTextField.delegate = self
        membersTextField.addTarget(self, action: #selector(membersFieldDidChange), for: .editingChanged)
        
        chosenUsersTableView.delegate = self
        chosenUsersTableView.dataSource = self
        self.chosenUsersTableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
        chosenUsersTableView.isHidden = false
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.isHidden = true
        usersTableView.layer.cornerRadius = 20
        usersTableView.layer.masksToBounds = true
        usersTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        usersTableView.layer.borderWidth = 1.0
    }
    
    @objc func membersFieldDidChange () {
        if membersTextField.text == "" {
            self.usersTableView.isHidden = true
            membersArray = []
            usersTableView.reloadData()
            self.chosenUsersTableView.isHidden = false
        } else {
            if chosenUsers.count == 0 {
                self.chosenUsersTableView.isHidden = true
            }
            
            DataService.instance.getFriends(forSearchQuery: membersTextField.text!, handler: { (friendsArray) in
                self.usersTableView.isHidden = false
                self.membersArray = friendsArray.filter { !self.chosenUsers.contains($0) }
                self.usersTableViewHeightConstraint.constant = CGFloat(self.membersArray.count * 40)
                self.usersTableView.reloadData()
            })
        }
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        var addedMembers = chosenUsers.filter { !self.currentUsers.contains($0) }
        var memberIds = [String]()
        DataService.instance.getIds(forEmails: addedMembers) { (ids) in
            memberIds = ids
            DataService.instance.addMember(toGroup: (self.group?.key)!, currentMembers: (self.group?.members)!, membersToAdd: memberIds) { (membersAdded) in
                if membersAdded {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        if tableView == chosenUsersTableView {
            numberOfRows = chosenUsers.count
        } else if tableView == usersTableView {
            numberOfRows = membersArray.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if tableView == chosenUsersTableView {
            guard let addUserCell = tableView.dequeueReusableCell(withIdentifier: "addUserCell", for: indexPath) as? AddUserCell else {return UITableViewCell()}
            addUserCell.configureCell(email: chosenUsers[indexPath.row], sender: "addMember")
            cell = addUserCell
        } else if tableView == usersTableView {
            if membersArray.count != 0 {
                guard let searchUserCell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserCell else {return UITableViewCell()}
                searchUserCell.configureCell(email: membersArray[indexPath.row], sender: "addMember")
                cell = searchUserCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == usersTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserCell else {return}
            if !chosenUsers.contains(cell.friendEmailLblFromGroup.text!) {
                chosenUsers.append(cell.friendEmailLblFromGroup.text!)
            }
            self.usersTableView.isHidden = true
            self.chosenUsersTableView.isHidden = false
            self.chosenUsersTableView.reloadData()
            self.chosenUsersTableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
            self.membersTextField.text = ""
        }
    }
}



extension AddMemberVC: UITextFieldDelegate {
    
}
