//
//  RemoveMembersVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-15.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class RemoveMembersVC: UIViewController {

    var chosenUsers = [String]()
    var group: Group?
    
    
    @IBOutlet weak var chosenUsersTableViewHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var chosenUsersTableView: UITableView!
    
    func initData (chosenGroup: Group) {
        self.group = chosenGroup
        DataService.instance.getEmails(group: chosenGroup) { (returnedEmails) in
            self.chosenUsers = returnedEmails
            self.chosenUsersTableView.reloadData()
            self.chosenUsersTableViewHeightConstrain.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenUsersTableView.delegate = self
        chosenUsersTableView.dataSource = self
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let point = chosenUsersTableView.convert(CGPoint.zero, from: sender)
        if let indexPath = chosenUsersTableView.indexPathForRow(at: point) {
            chosenUsers = chosenUsers.filter { $0 != chosenUsers[indexPath.row]}
        }
        chosenUsersTableView.reloadData()
        self.chosenUsersTableViewHeightConstrain.constant = CGFloat(self.chosenUsers.count) * self.chosenUsersTableView.rowHeight
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
        cell.configureCell(email: chosenUsers[indexPath.row], sender: "removeMember")
        return cell
    }
}
