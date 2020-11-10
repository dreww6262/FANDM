//
//  SignInVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/27/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class LogInVC: UIViewController, UITextFieldDelegate {
    
    let usernameInput = UITextField()
    let pswdInput = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        
        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        
        let logoPic = UIImageView()
        view.addSubview(logoPic)
        logoPic.frame = CGRect(x: view.frame.midX - 80, y: 60, width: 160, height: 85)
        logoPic.image = UIImage(named: "Logo")
        logoPic.contentMode = .scaleAspectFit
        
        
        view.addSubview(usernameInput)
        usernameInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        usernameInput.frame = CGRect(x: 32, y: view.frame.midY - 100, width: view.frame.width - 64, height: 20)
        usernameInput.backgroundColor = .clear
        usernameInput.textColor = .white
        usernameInput.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        view.addSubview(pswdInput)
        pswdInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        pswdInput.frame = CGRect(x: 32, y: usernameInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        pswdInput.backgroundColor = .clear
        pswdInput.textColor = .white
        pswdInput.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        pswdInput.isSecureTextEntry = true
        
        pswdInput.delegate = self
        usernameInput.delegate = self
        
        let forgotPswdButton = UIButton()
        view.addSubview(forgotPswdButton)
        forgotPswdButton.setTitle("Forgot Password?", for: .normal)
        forgotPswdButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 12)
        forgotPswdButton.setTitleColor(.white, for: .normal)
        forgotPswdButton.sizeToFit()
        forgotPswdButton.frame = CGRect(x: pswdInput.frame.minX, y: pswdInput.frame.maxY + 8, width: forgotPswdButton.frame.width, height: forgotPswdButton.frame.height)
        forgotPswdButton.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 22, width: usernameInput.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        usernameInput.borderStyle = UITextField.BorderStyle.none
        usernameInput.layer.addSublayer(bottomLine)
        let secondBottomLine = CALayer()
        secondBottomLine.frame = bottomLine.frame
        secondBottomLine.backgroundColor = UIColor.white.cgColor
        pswdInput.borderStyle = UITextField.BorderStyle.none
        pswdInput.layer.addSublayer(secondBottomLine)

        let backButton = UIButton()
        view.addSubview(backButton)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        let backPressed = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButton.addGestureRecognizer(backPressed)
        
        backButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: view.frame.midY + 50, width: 280, height: 45)
        backButton.layer.cornerRadius = 22
        backButton.clipsToBounds = true
        backButton.backgroundColor = .clear
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 2
        
        let logInButton = UIButton()
        view.addSubview(logInButton)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        logInButton.setTitleColor(UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00), for: .normal)
        logInButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: backButton.frame.maxY + 8, width: 280, height: 45)
        logInButton.layer.cornerRadius = 22
        logInButton.clipsToBounds = true
        logInButton.isUserInteractionEnabled = true
        logInButton.backgroundColor = .white
        let logInTap = UITapGestureRecognizer(target: self, action: #selector(logInPressed))
        logInButton.addGestureRecognizer(logInTap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func forgotTapped(_sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Is your email inputted correctly?", message: "Make sure your email is inputted in this screen.  Click \"Continue\" to send password reset to your email or click \"Back\" and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            Auth.auth().sendPasswordReset(withEmail: self.usernameInput.text!, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        clearInputs()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func logInPressed(_ sender: UITapGestureRecognizer) {
        let auth = Auth.auth()
        
        if (usernameInput.text!.isEmpty && pswdInput.text!.isEmpty) {
            let alert = UIAlertController(title: "Unable to sign in.", message: "Please enter your email and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        else if (usernameInput.text!.isEmpty) {
            let alert = UIAlertController(title: "Unable to sign in.", message: "Please enter your email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        else if (pswdInput.text!.isEmpty) {
            let alert = UIAlertController(title: "Unable to sign in.", message: "Please enter your password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        auth.signIn(withEmail: usernameInput.text!, password: pswdInput.text!, completion:  { result, error   in
            if error != nil {
                let alert = UIAlertController(title: "Unable to sign in.", message: "Invalid email or password.  Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            self.performSegue(withIdentifier: "rewindFromLogIn", sender: self)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let accountVC = segue.destination as! AccountVC
//        accountVC.user = user
//        accountVC.userData = userData
    }
    
    func clearInputs() {
        usernameInput.text = ""
        pswdInput.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
