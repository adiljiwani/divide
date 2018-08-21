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
    let logoImageView = UIImageView()
    
    @IBOutlet weak var backView: UIView!
    var offsetY:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        //errorLbl.isHidden = true
        
        view.addSubview(gradientView)
        gradientView <- [Edges()]
        gradientView.topColor = UI.Colours.gradientTopColour
        gradientView.bottomColor = UI.Colours.gradientBottomColour
        
        setupLogo()
        setupSubtitle()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignUpButton()
        setupForgotPasswordButton()
    }
    
    func setupLogo() {
        view.addSubview(logoImageView)
        //logoImageView.frame = CGRect(x: 50, y: 50, width: 106, height: 31)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView <- [
            Top(50),
            CenterX()
        ]
    }
    
    func setupSubtitle() {
        view.addSubview(subtitleLabel)
        subtitleLabel.text = "Splitting money\nthe easy way"
        subtitleLabel.font = UI.Font.regular(22)
        subtitleLabel.textColor = UI.Colours.white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel <- [Top(30).to(logoImageView, .bottom), CenterX()]
    }
    
    func setupEmailTextField() {
        view.addSubview(emailTextField)
        let data = TextFieldEntryData(title: "Email address", placeholder: "hello@divide.com")
        emailTextField.configure(data)
        emailTextField.tintColor = UI.Colours.white

//        let emailImageView = UIImageView(image: UIImage(named: "email"))
//        emailImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        emailTextField.leftViewMode = .always
//        emailTextField.leftView = emailImageView
        emailTextField <- [
            Top(200),
            Height(30),
            Left(30),
            Right(30)
        ]
    }
    
    func setupPasswordTextField() {
        view.addSubview(passwordTextField)
        let data = TextFieldEntryData(title: "Password", placeholder: "********")
        emailTextField.configure(data)
        emailTextField.tintColor = UI.Colours.white
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
        if emailTextField.textField.text != "" && passwordTextField.textField.text != "" {
            AuthService.instance.loginUser(withEmail: emailTextField.textField.text!, andPassword: passwordTextField.textField.text!, loginComplete: { (success, loginError) in
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
