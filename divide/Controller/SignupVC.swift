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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpPressed(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        if emailTextField.text != nil && passwordField.text != nil && nameTextField.text != nil {
        AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passwordField.text!, name: nameTextField.text!, userCreationComplete: { (success, registrationError) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                    self.presentDetail(tabBar!)
                })
            } else {
                print(String(describing: registrationError?.localizedDescription))
            }
        })
        }
    }
    
}
