//
//  SignInVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/27/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen
        
        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        
        let logoPic = UIImageView()
        view.addSubview(logoPic)
        logoPic.frame = CGRect(x: view.frame.midX - 80, y: 60, width: 160, height: 85)
        logoPic.image = UIImage(named: "Logo")
        logoPic.contentMode = .scaleAspectFit
        
        let usernameInput = UITextField()
        view.addSubview(usernameInput)
        usernameInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        usernameInput.frame = CGRect(x: 32, y: view.frame.midY - 100, width: view.frame.width - 64, height: 20)
        usernameInput.backgroundColor = .clear
        usernameInput.textColor = .white
        usernameInput.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let pswdInput = UITextField()
        view.addSubview(pswdInput)
        pswdInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        pswdInput.frame = CGRect(x: 32, y: usernameInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        pswdInput.backgroundColor = .clear
        pswdInput.textColor = .white
        pswdInput.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        pswdInput.isSecureTextEntry = true
        
        let forgotPswdButton = UIButton()
        view.addSubview(forgotPswdButton)
        forgotPswdButton.setTitle("Forgot Password?", for: .normal)
        forgotPswdButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 12)
        let forgotTap = UITapGestureRecognizer(target: self, action: #selector(forgotPressed))
        forgotPswdButton.addGestureRecognizer(forgotTap)
        forgotPswdButton.setTitleColor(.white, for: .normal)
        forgotPswdButton.sizeToFit()
        forgotPswdButton.frame = CGRect(x: pswdInput.frame.minX, y: pswdInput.frame.maxY + 8, width: forgotPswdButton.frame.width, height: forgotPswdButton.frame.height)
        
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
    

    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        clearInputs()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func logInPressed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "rewindFromLogIn", sender: self)
    }
    
    @objc func forgotPressed(_ sender: UITapGestureRecognizer) {
        // TODO: implement forgot password
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let accountVC = segue.destination as! AccountVC
//        accountVC.user = user
//        accountVC.userData = userData
    }
    
    func clearInputs() {
        
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
