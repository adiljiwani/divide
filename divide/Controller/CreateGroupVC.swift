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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIButton!
   
    @IBOutlet weak var addBtn: RoundedButton!
    
    var matchEmail: String = ""
    var chosenUsers = [String]()
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        membersField.delegate = self
        self.tableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.tableView.rowHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addPressed(_ sender: Any) {
        if membersField.text! == "" && chosenUsers.contains(membersField.text!){
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: membersField.text!, handler: { (returnedEmail) in
                self.matchEmail = returnedEmail
                DataService.instance.addFriend(byEmail: self.matchEmail, handler: { (added) in
                    
                })
                self.chosenUsers.append(self.matchEmail)
                self.doneBtn.isHidden = false
                self.tableView.reloadData()
                self.membersField.text = ""
                self.tableViewHeightConstraint.constant = CGFloat(self.chosenUsers.count) * self.tableView.rowHeight
            })
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if groupNameField.text != "" && membersField.text != "" {
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
        
        tableView.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addUserCell", for: indexPath) as? AddUserCell else {return UITableViewCell()}
        cell.configureCell(email: chosenUsers[indexPath.row])
        return cell
    }
}

extension CreateGroupVC: UITextFieldDelegate {
    
}
