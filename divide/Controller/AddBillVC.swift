//
//  AddBillVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-03.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AddBillVC: UIViewController {

    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var groupField: InsetTextField!
    @IBOutlet weak var billDescriptionField: InsetTextField!
    @IBOutlet weak var amountField: InsetTextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var paidByField: InsetTextField!
    var groupArray = [String]()
    var chosenGroup: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupField.delegate = self
        groupField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        groupsTableView.isHidden = true
        groupsTableView.layer.cornerRadius = 20
        groupsTableView.layer.masksToBounds = true
    }
    
    @objc func textFieldDidChange () {
        if groupField.text == "" {
            self.groupsTableView.isHidden = true
            groupArray = []
            groupsTableView.reloadData()
        } else {
            self.groupsTableView.isHidden = false
            DataService.instance.getGroupNames(forSearchQuery: groupField.text!, handler: { (groupNameArray) in
                self.groupArray = groupNameArray
                self.groupsTableView.reloadData()
            })
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if billDescriptionField.text != "" && amountField.text != "" {
            
        }
    }
}

extension AddBillVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchGroupCell") as? SearchGroupCell else {return UITableViewCell()}
        cell.configureCell(groupName: groupArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchGroupCell else {return}
        chosenGroup = cell.groupNameLbl.text!
        self.groupField.text = chosenGroup
        self.groupsTableView.isHidden = true
    }
}

extension AddBillVC: UITextFieldDelegate {
    
}
