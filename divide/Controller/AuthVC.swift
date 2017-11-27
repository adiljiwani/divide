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
    var offsetY:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passTxtField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
    @objc func keyboardFrameChangeNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
            let animationCurveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int) ?? Int(UIViewAnimationOptions.curveEaseInOut.rawValue)
            let animationCurve = UIViewAnimationOptions(rawValue: UInt(animationCurveRawValue))
            if let _ = endFrame, endFrame!.intersects(self.loginBtn.frame) {
                self.offsetY = self.loginBtn.frame.maxY - endFrame!.minY
                UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
                    self.loginBtn.frame.origin.y = self.loginBtn.frame.origin.y - self.offsetY
                }, completion: nil)
            } else {
                if self.offsetY != 0 {
                    UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
                        self.loginBtn.frame.origin.y = self.loginBtn.frame.origin.y + self.offsetY
                        self.offsetY = 0
                    }, completion: nil)
                }
            }
        }
    }
    
}

extension AuthVC: UITextFieldDelegate {
    
}
