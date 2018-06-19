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
    let subtitleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UnderlineTextField()
    let loginBtn = RoundedButton()
    
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
        setupSubtitle()
        setupLoginButton()
        view.backgroundColor = UI.Colours.background
    }
    
    func setupSubtitle() {
        view.addSubview(subtitleLabel)
        subtitleLabel.text = "Splitting money\nthe easy way"
        subtitleLabel.font = UI.Font.demiBold(25)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel <- [Top(100), CenterX()]
    }
    
    func setupEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.minimumFontSize = 17
        emailTextField.clearButtonMode = .never
        emailTextField.font = UI.Font.regular(15)
        let placeholder = NSMutableAttributedString(string: "Email address")
        placeholder.addAttribute(NSAttributedStringKey.foregroundColor, value: UI.Colours.placeholderTextColour, range: NSMakeRange(0, placeholder.length))
        emailTextField.attributedPlaceholder = placeholder
        emailTextField.tintColor = UI.Colours.offBlack
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField <- [
            Top(200),
            Left(50),
            Right(50)
        ]
    }
    
    func setupPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.minimumFontSize = 17
        passwordTextField.clearButtonMode = .never
        passwordTextField.font = UI.Font.regular(15)
        let placeholder = NSMutableAttributedString(string: "Password")
        placeholder.addAttribute(NSAttributedStringKey.foregroundColor, value: UI.Colours.placeholderTextColour, range: NSMakeRange(0, placeholder.length))
        passwordTextField.attributedPlaceholder = placeholder
        passwordTextField.tintColor = UI.Colours.offBlack
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.masksToBounds = true
        passwordTextField <- [
            Top(20).to(emailTextField),
            Left(50),
            Right(50)
        ]
        passwordTextField.layer.masksToBounds = true
    }
    
    func setupLoginButton() {
        view.addSubview(loginBtn)
        loginBtn.backgroundColor = UI.Colours.pink
        loginBtn.titleLabel?.textColor = UI.Colours.white
        loginBtn.titleLabel?.font = UI.Font.demiBold(14)
        loginBtn.setTitle("LOG IN", for: .normal)
        loginBtn.cornerRadius = 20
        loginBtn.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        loginBtn <- [
            Top(40).to(passwordTextField),
            Left(50),
            Right(50),
            Height(40)
        ]
    }

    @objc func loginPressed(_ sender: Any) {
        let homeVC = HomeVC()
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.presentDetail(homeVC)
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
