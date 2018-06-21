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
    let emailTextField = UnderlineTextField()
    let passwordTextField = UnderlineTextField()
    let loginButton = RoundedButton()
    let forgotPasswordButton = UIButton()
    let signUpButton = UIButton()
    let gradientView = GradientView()
    
    @IBOutlet weak var backView: UIView!
    var offsetY:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        UIApplication.shared.statusBarStyle = .lightContent
        //errorLbl.isHidden = true
        
        view.addSubview(gradientView)
        gradientView <- [Edges()]
        gradientView.topColor = UI.Colours.gradientTopColour
        gradientView.bottomColor = UI.Colours.gradientBottomColour
        
        setupEmailTextField()
        setupPasswordTextField()
        setupSubtitle()
        setupLoginButton()
        setupSignUpButton()
        setupForgotPasswordButton()
    }
    
    override func viewDidLayoutSubviews() {
        emailTextField.underlined()
        passwordTextField.underlined()
    }
    
    func setupSubtitle() {
        view.addSubview(subtitleLabel)
        subtitleLabel.text = "Splitting money\nthe easy way"
        subtitleLabel.font = UI.Font.regular(22)
        subtitleLabel.textColor = UI.Colours.white
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
        placeholder.addAttribute(NSAttributedStringKey.foregroundColor, value: UI.Colours.lightGrey, range: NSMakeRange(0, placeholder.length))
        emailTextField.attributedPlaceholder = placeholder
        emailTextField.tintColor = UI.Colours.white
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textColor = UI.Colours.white
        emailTextField <- [
            Top(200),
            Height(30),
            Left(30),
            Right(30)
        ]
    }
    
    func setupPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.minimumFontSize = 17
        passwordTextField.clearButtonMode = .never
        passwordTextField.font = UI.Font.regular(15)
        let placeholder = NSMutableAttributedString(string: "Password")
        placeholder.addAttribute(NSAttributedStringKey.foregroundColor, value: UI.Colours.lightGrey, range: NSMakeRange(0, placeholder.length))
        passwordTextField.attributedPlaceholder = placeholder
        passwordTextField.tintColor = UI.Colours.white
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UI.Colours.white
        passwordTextField.isSecureTextEntry = true
        passwordTextField <- [
            Top(25).to(emailTextField),
            Height(30),
            Left(30),
            Right(30)
        ]
    }
    
    func setupLoginButton() {
        view.addSubview(loginButton)
        loginButton.backgroundColor = UI.Colours.pink
        loginButton.titleLabel?.textColor = UI.Colours.white
        loginButton.titleLabel?.font = UI.Font.demiBold(18)
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.cornerRadius = 25
        loginButton.addTarget(self, action: #selector(loginPressed(_:)), for: .touchUpInside)
        loginButton <- [
            Top(40).to(passwordTextField),
            Left(30),
            Right(30),
            Height(50)
        ]
    }
    
    func setupForgotPasswordButton() {
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.titleLabel?.textColor = UI.Colours.lightGrey
        forgotPasswordButton.titleLabel?.font = UI.Font.regular(15)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton <- [
            Top(8).to(loginButton),
            CenterX()
        ]
    }
    
    func setupSignUpButton() {
        view.addSubview(signUpButton)
        let signUpString = NSMutableAttributedString(string: "Don't have an account? SIGN UP")
        signUpString.addAttributes([NSAttributedStringKey.foregroundColor: UI.Colours.lightGrey, NSAttributedStringKey.font: UI.Font.regular(15)], range: NSMakeRange(0, signUpString.length - 7))
        signUpString.addAttributes([NSAttributedStringKey.foregroundColor: UI.Colours.white, NSAttributedStringKey.font: UI.Font.demiBold(15)], range: NSMakeRange(signUpString.length - 7, 7))
        signUpButton.setAttributedTitle(signUpString, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpPressed(_:)), for: .touchUpInside)
        signUpButton <- [
            Bottom(30),
            CenterX()
        ]
    }

    @objc func loginPressed(_ sender: Any) {
        let homeVC = HomeVC()
        //let tabBar = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.presentDetail(homeVC)
                    UIApplication.shared.statusBarStyle = .lightContent
                } else {
                    if let error = loginError?.localizedDescription {
                        print(error)
                        //self.errorLbl.isHidden = false
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
    
    @objc func signUpPressed(_ sender: Any) {
        let signUpVC = SignupVC()
        presentDetail(signUpVC)
    }
}

extension AuthVC: UITextFieldDelegate {

}
