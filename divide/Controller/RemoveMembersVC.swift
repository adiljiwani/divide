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
    
    @IBOutlet weak var chosenUsersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
