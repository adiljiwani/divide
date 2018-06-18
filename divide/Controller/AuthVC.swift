//
//  AuthVC.swift
//  divide
//
//  Created by Adil Jiwani on 2017-11-25.
//  Copyright © 2017 Adil Jiwani. All rights reserved.
//

import UIKit
import EasyPeasy

class AuthVC: UIViewController {

    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var loginBtn: RoundedOutlineButton!
    
    @IBOutlet weak var passTextField: InsetTextField!
 
    //@IBOutlet weak var emailTextField: InsetTextField!
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    @IBOutlet weak var backView: UIView!
    var offsetY:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        UIApplication.shared.statusBarStyle = .default
        //errorLbl.isHidden = true
        setupEmailTextField()
        setupPasswordTextField()
        view.backgroundColor = UI.Colours.background
    }
    
    func setupEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.minimumFontSize = 17
        emailTextField.clearButtonMode = .never
        emailTextField.placeholder = "Email address"
        emailTextField <- [Top(40), Left(50), Right(50), Height(30)]
    }
    
    func setupPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.minimumFontSize = 17
        passwordTextField.clearButtonMode = .never
        passwordTextField.placeholder = "Password"
        passwordTextField <- [Top(20), Left(50), Right(50), Height(30)]
    }

    @IBAction func loginPressed(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        if emailTextField.text != "" && passTextField.text != "" {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passTextField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.presentDetail(tabBar!)
                    UIApplication.shared.statusBarStyle = .lightContent
                } else {
                    if let error = loginError?.localizedDescription {
                        print(error)
                        self.errorLbl.isHidden = false
                        if error == "The password must be 6 characters long or more." {
                            self.errorLbl.text = error
                        } else if error == "The email address is badly formatted." {
                            self.errorLbl.text = "Please enter a valid email address."
                        } else if error == "The email address is already in use by another account." {
                            self.errorLbl.text = "This user already has a divide account. Please log in."
                        } else if error == "There is no user record corresponding to this identifier. The user may have been deleted." {
                            self.errorLbl.text = "Please press the Sign Up button to create an account first."
                        } else if error == "The password is invalid or the user does not have a password." {
                            self.errorLbl.text = "Incorrect password."
                        }
                    }
                }
            })
        }
    }
}

extension AuthVC: UITextFieldDelegate {

}
