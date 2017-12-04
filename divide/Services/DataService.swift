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
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
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
    
    func getGroupNames (forSearchQuery query: String, handler: @escaping (_ groupNames: [String]) -> ()) {
        var groupNames = [String]()
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("groups").observe(.value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapshot {
                let groupName = group.childSnapshot(forPath: "title").value as! String
                if groupName.contains(query) {
                    groupNames.append(groupName)
                }
            }
            handler(groupNames)
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
    
    func createGroup (withTitle title: String, description: String, ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        let groupRef = REF_GROUPS.childByAutoId()
        groupRef.updateChildValues(["title": title, "description": description, "members": ids])
        for userId in ids {
            REF_USERS.child(userId).child("groups").child(groupRef.key).updateChildValues(["title": title, "members": ids])
        }
        handler(true)
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
