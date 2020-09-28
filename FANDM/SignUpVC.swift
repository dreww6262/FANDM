//
//  SignUpVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/27/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        
        self.modalPresentationStyle = .fullScreen
        
        let logoPic = UIImageView()
        view.addSubview(logoPic)
        logoPic.frame = CGRect(x: view.frame.midX - 80, y: 60, width: 160, height: 85)
        logoPic.image = UIImage(named: "Logo")
        logoPic.contentMode = .scaleAspectFit
        
        let firstNameInput = UITextField()
        view.addSubview(firstNameInput)
        firstNameInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        firstNameInput.frame = CGRect(x: 32, y: logoPic.frame.maxY + 64, width: view.frame.width - 64, height: 20)
        firstNameInput.backgroundColor = .clear
        firstNameInput.textColor = .white
        firstNameInput.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        firstNameInput.layer.addSublayer(createBottomLine(forInput: firstNameInput))
        
        let lastNameInput = UITextField()
        view.addSubview(lastNameInput)
        lastNameInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        lastNameInput.frame = CGRect(x: 32, y: firstNameInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        lastNameInput.backgroundColor = .clear
        lastNameInput.textColor = .white
        lastNameInput.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameInput.layer.addSublayer(createBottomLine(forInput: lastNameInput))
        
        let emailInput = UITextField()
        view.addSubview(emailInput)
        emailInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        emailInput.frame = CGRect(x: 32, y: lastNameInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        emailInput.backgroundColor = .clear
        emailInput.textColor = .white
        emailInput.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailInput.layer.addSublayer(createBottomLine(forInput: emailInput))
        
        let usernameInput = UITextField()
        view.addSubview(usernameInput)
        usernameInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        usernameInput.frame = CGRect(x: 32, y: emailInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        usernameInput.backgroundColor = .clear
        usernameInput.textColor = .white
        usernameInput.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        usernameInput.layer.addSublayer(createBottomLine(forInput: usernameInput))
        
        let passwordInput = UITextField()
        view.addSubview(passwordInput)
        passwordInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        passwordInput.frame = CGRect(x: 32, y: usernameInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        passwordInput.backgroundColor = .clear
        passwordInput.textColor = .white
        passwordInput.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordInput.layer.addSublayer(createBottomLine(forInput: passwordInput))
        passwordInput.isSecureTextEntry = true
        
        let repeatInput = UITextField()
        view.addSubview(repeatInput)
        repeatInput.font = UIFont(name: "Poppins-SemiBold", size: 18)
        repeatInput.frame = CGRect(x: 32, y: passwordInput.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        repeatInput.backgroundColor = .clear
        repeatInput.textColor = .white
        repeatInput.attributedPlaceholder = NSAttributedString(string: "Repeat Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        repeatInput.layer.addSublayer(createBottomLine(forInput: repeatInput))
        repeatInput.isSecureTextEntry = true
        
        let backButton = UIButton()
        view.addSubview(backButton)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        let backPressed = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButton.addGestureRecognizer(backPressed)
        
        backButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: repeatInput.frame.maxY + 64, width: 280, height: 45)
        backButton.layer.cornerRadius = 22
        backButton.clipsToBounds = true
        backButton.backgroundColor = .clear
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderWidth = 2
        
        let createAcctButton = UIButton()
        view.addSubview(createAcctButton)
        createAcctButton.setTitle("Create Account", for: .normal)
        createAcctButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        createAcctButton.setTitleColor(UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00), for: .normal)
        createAcctButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: backButton.frame.maxY + 8, width: 280, height: 45)
        createAcctButton.layer.cornerRadius = 22
        createAcctButton.clipsToBounds = true
        createAcctButton.isUserInteractionEnabled = true
        createAcctButton.backgroundColor = .white
        let logInTap = UITapGestureRecognizer(target: self, action: #selector(createAcctButtonPressed))
        createAcctButton.addGestureRecognizer(logInTap)

        // Do any additional setup after loading the view.
    }
    
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        clearInputs()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func createAcctButtonPressed(_ sender: UITapGestureRecognizer) {
        let surveyVC = storyboard!.instantiateViewController(identifier: "surveyVC")
        surveyVC.modalPresentationStyle = .fullScreen
        for view in view.subviews {
            view.removeFromSuperview()
        }
        self.present(surveyVC, animated: false, completion: nil)
    }
    
    func clearInputs() {
        
    }
    
    func createBottomLine(forInput: UITextField) -> CALayer {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 22, width: forInput.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        forInput.borderStyle = UITextField.BorderStyle.none
        forInput.layer.addSublayer(bottomLine)
        return bottomLine
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
