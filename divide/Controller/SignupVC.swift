//
//  SignupVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-12-08.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var nameTextField: InsetTextField!
    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
    }

    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpPressed(_ sender: Any) {
        if nameTextField.text != "" && emailTextField.text != "" && passwordField.text != "" {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        if emailTextField.text != nil && passwordField.text != nil && nameTextField.text != nil {
        AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passwordField.text!, name: nameTextField.text!, userCreationComplete: { (success, registrationError) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                    self.presentDetail(tabBar!)
                    UIApplication.shared.statusBarStyle = .lightContent
                })
            } else {
                if let error = registrationError?.localizedDescription  {
                print(error)
                    self.errorLbl.isHidden = false
                    if error == "The password must be 6 characters long or more." {
                        self.errorLbl.text = error
                    } else if error == "The email address is badly formatted." {
                        self.errorLbl.text = "Please enter a valid email address."
                    } else if error == "The email address is already in use by another account." {
                        self.errorLbl.text = "This user already has a divide account. Please log in."
                    }
                }
            }
        })
        }
        } else {
            
        }
    }
    
}
