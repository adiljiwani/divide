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
    @IBOutlet weak var loginBtn: RoundedOutlineButton!
    
    @IBOutlet weak var passTextField: InsetTextField!
 
    @IBOutlet weak var emailTextField: InsetTextField!
    
    @IBOutlet weak var backView: UIView!
    var offsetY:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passTextField.delegate = self
    }

    @IBAction func loginPressed(_ sender: Any) {
        if emailTextField.text != nil && passTextField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passTextField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passTextField.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passTextField.text!, loginComplete: { (success, nil) in
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
