//
//  CreateGroupVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-27.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupNameField: InsetTextField!
    
    @IBOutlet weak var descriptionField: InsetTextField!
    
    @IBOutlet weak var membersField: InsetTextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIButton!
   
    @IBOutlet weak var addBtn: RoundedButton!
    
    var matchEmail: String = "ahaha"
    var chosenUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        membersField.delegate = self
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
                self.chosenUsers.append(self.matchEmail)
                self.tableView.reloadData()
                self.membersField.text = ""
            })
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
    }
    
//    @IBAction func deletePressed(_ sender: Any) {
//        chosenUsers = chosenUsers.filter({ $0 != "adiljiwani@gmail.com" })
//        tableView.reloadData()
//    }
    
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
