//
//  AuthVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-25.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var passTxtField: InsetTextField!
    @IBOutlet weak var loginBtn: RoundedOutlineButton!
    @IBOutlet weak var emailTxtField: InsetTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passTxtField.delegate = self
    }

    @IBAction func loginPressed(_ sender: Any) {
        if emailTxtField.text != nil && passTxtField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTxtField.text!, andPassword: passTxtField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: self.passTxtField.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passTxtField.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered user.")
                        })
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })
            })
        }
    }
    
    
}

extension AuthVC: UITextFieldDelegate {
    
}
