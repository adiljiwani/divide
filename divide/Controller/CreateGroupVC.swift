//
//  CreateGroupVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-27.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupNameField: InsetTextField!
    
    @IBOutlet weak var membersField: InsetTextField!
    
    @IBOutlet weak var chosenUsersTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var usersTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var doneBtn: UIButton!
   
    @IBOutlet weak var addBtn: RoundedButton!
    
    var matchEmail: String = ""
    var chosenUsers = [String]()
    var membersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenUsersTableView.delegate = self
        chosenUsersTableView.dataSource = self
        membersField.delegate = self
        self.tableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
        chosenUsersTableView.isHidden = false
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        membersField.addTarget(self, action: #selector(membersFieldDidChange), for: .editingChanged)
        usersTableView.isHidden = true
        usersTableView.layer.cornerRadius = 20
        usersTableView.layer.masksToBounds = true
        usersTableView.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        usersTableView.layer.borderWidth = 1.0
    }
    
    @objc func membersFieldDidChange () {
        if membersField.text == "" {
            self.usersTableView.isHidden = true
            membersArray = []
            usersTableView.reloadData()
            self.chosenUsersTableView.isHidden = false
        } else {
            if chosenUsers.count == 0 {
                self.chosenUsersTableView.isHidden = true
            }

            DataService.instance.getFriends(forSearchQuery: membersField.text!, handler: { (friendsArray) in
                self.usersTableView.isHidden = false
                self.membersArray = friendsArray.filter { !self.chosenUsers.contains($0) }
                self.usersTableViewHeightConstraint.constant = CGFloat(self.membersArray.count * 40)
                self.usersTableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addPressed(_ sender: Any) {
        if membersField.text! == "" && chosenUsers.contains(membersField.text!){
            chosenUsersTableView.reloadData()
        } else {
            chosenUsersTableView.isHidden = false
            usersTableView.isHidden = true
            DataService.instance.getEmail(forSearchQuery: membersField.text!, handler: { (returnedEmail) in
                DataService.instance.addFriend(byEmail: returnedEmail, handler: { (added) in
                    if added {
                        self.chosenUsers.append(returnedEmail)
                        self.doneBtn.isHidden = false
                        self.chosenUsersTableView.reloadData()
                        self.membersField.text = ""
                        self.tableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
                    }
                })
                
            })
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if groupNameField.text != "" && chosenUsers.count != 0 {
            DataService.instance.getIds(forEmails: chosenUsers, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                DataService.instance.createGroup(withTitle: self.groupNameField.text!, ids: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Group could not be created.")
                    }
                })
            })
        }
    }
    

    @IBAction func deletePressed(_ sender: UIButton) {
        //chosenUsers = chosenUsers.filter({ $0 != "adiljiwani@gmail.com" })
        if chosenUsers.count == 0 {
            doneBtn.isHidden = true
        }
        
        chosenUsersTableView.reloadData()
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
            addUserCell.configureCell(email: chosenUsers[indexPath.row])
            cell = addUserCell
        } else if tableView == usersTableView {
            if membersArray.count != 0 {
                guard let searchUserCell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell") as? SearchUserCell else {return UITableViewCell()}
                searchUserCell.configureCell(email: membersArray[indexPath.row], sender: "group")
                cell = searchUserCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == usersTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserCell else {return}
            if !chosenUsers.contains(cell.friendEmailLbl.text!) {
                chosenUsers.append(cell.friendEmailLbl.text!)
            }
            self.usersTableView.isHidden = true
            self.chosenUsersTableView.isHidden = false
            self.chosenUsersTableView.reloadData()
            self.tableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
            self.membersField.text = ""
        }
    }
}

extension CreateGroupVC: UITextFieldDelegate {
    
}
