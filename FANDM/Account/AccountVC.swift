//
//  AccountVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase


class AccountVC: UIViewController {
    
    var infoChild: AccountInfoVC?
    var infoView: UIView?
    var userData: UserData?
    
    let settingsButton = UIButton()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
    
        let logoPic = UIImageView()
        view.addSubview(logoPic)
        logoPic.frame = CGRect(x: view.frame.midX - 80, y: 60, width: 160, height: 85)
        logoPic.image = UIImage(named: "Logo")
        logoPic.contentMode = .scaleAspectFit
        
        view.addSubview(settingsButton)
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        settingsButton.frame = CGRect(x: 32, y: logoPic.frame.midY - 24, width: 32, height: 32)
        settingsButton.backgroundColor = .clear
        settingsButton.tintColor = .clear
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        let smallText = UILabel()
        view.addSubview(smallText)
        smallText.frame = CGRect(x: 0, y: 0, width: view.frame.width - 64, height: 0)
        smallText.text = "Welcome to First & Main, The Offical Entertainment Destination of Virginia Tech Athletics and your favorite place for great food, shopping, and entertainment located in Blacksburg, Virginia."
        smallText.textAlignment = .center
        smallText.textColor = .white
        smallText.font = UIFont(name: "Poppins-SemiBold", size: 14)
        smallText.backgroundColor = .clear
        smallText.tintColor = .clear
        smallText.numberOfLines = 0
        smallText.sizeToFit()
        smallText.frame = CGRect(x: 32, y: view.frame.midY - smallText.frame.height/2, width: smallText.frame.width, height: smallText.frame.height)
        
        let welcomeText = UILabel()
        view.addSubview(welcomeText)
        welcomeText.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        welcomeText.text = "Welcome."
        welcomeText.textAlignment = .center
        welcomeText.textColor = .white
        welcomeText.font = UIFont(name: "Poppins-SemiBold", size: 36)
        welcomeText.backgroundColor = .clear
        welcomeText.tintColor = .clear
        welcomeText.numberOfLines = 1
        welcomeText.sizeToFit()
        welcomeText.frame = CGRect(x: view.frame.midX - welcomeText.frame.width/2, y: smallText.frame.minY - 16 - 36, width: welcomeText.frame.width, height: welcomeText.frame.height)
        
        view.bringSubviewToFront(smallText)
        view.bringSubviewToFront(welcomeText)
        
        let logInButton = UIButton()
        view.addSubview(logInButton)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        let yOffset = smallText.frame.maxY + (view.frame.height - smallText.frame.maxY) / 2 - 53
        logInButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: yOffset, width: 280, height: 45)
        logInButton.layer.cornerRadius = 22
        logInButton.clipsToBounds = true
        logInButton.layer.borderColor = UIColor.white.cgColor
        logInButton.layer.borderWidth = 2
        logInButton.isUserInteractionEnabled = true
        let logInTap = UITapGestureRecognizer(target: self, action: #selector(logInPressed))
        logInButton.addGestureRecognizer(logInTap)
        
        
        let signUpButton = UIButton()
        view.addSubview(signUpButton)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        signUpButton.setTitleColor(UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00), for: .normal)
        signUpButton.frame = CGRect(x: logInButton.frame.minX, y: logInButton.frame.maxY + 8, width: logInButton.frame.width, height: logInButton.frame.height)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 22
        signUpButton.clipsToBounds = true
        signUpButton.isUserInteractionEnabled = true
        let signUpTap = UITapGestureRecognizer(target: self, action: #selector(signUpPressed))
        signUpButton.addGestureRecognizer(signUpTap)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let email = Auth.auth().currentUser?.email ?? ""

        if (email != "") {
            db.collection("UserData").whereField("email", isEqualTo: email).getDocuments(completion: {obj, error in
                guard let docs = obj?.documents else {
                    return
                }
                if docs.count > 0 {
                    self.userData = UserData(dictionary: docs[0].data())
                }
            })
        }
        
        navigationController?.navigationBar.tintColor = .black
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.barTintColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        navBar?.isHidden = true
        
        if Auth.auth().currentUser != nil {
            
            
            if (infoChild == nil || infoView == nil){
                infoView?.removeFromSuperview()
                infoChild?.removeFromParent()
                infoChild = AccountInfoVC()
                infoView = infoChild!.view
                addChild(infoChild!)
                view.addSubview(infoView!)
                infoView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - ((tabBarController?.tabBar.frame.height) ?? 0))
                infoChild!.setup()
                settingsButton.isHidden = true
            }
            
            // Alert made above.  actually use this to transition to account info
        }
        else {
            infoView?.removeFromSuperview()
            infoChild?.removeFromParent()
            infoView = nil
            infoChild = nil
            settingsButton.isHidden = false
        }
    }
    
    @objc func logInPressed(_ sender: UITapGestureRecognizer) {
        let logInVC = storyboard!.instantiateViewController(identifier: "logInVC")
        self.present(logInVC, animated: false, completion: nil)
        logInVC.modalPresentationStyle = .fullScreen
    }
    
    @objc func signUpPressed(_ sender: UITapGestureRecognizer) {
        let signUpVC = storyboard!.instantiateViewController(identifier: "signUpVC")
        self.present(signUpVC, animated: false, completion: nil)
        signUpVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func rewindToAccountAndSignIn(segue: UIStoryboardSegue) {
        let source = segue.source
        if source is SurveyVC {
            // signup
        }
        else {
            // do nothing for now
        }
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let settingsVC = storyboard?.instantiateViewController(identifier: "settingsVC") as! SettingsVC
        let email = Auth.auth().currentUser?.email ?? ""
        if userData != nil {
            settingsVC.userData = userData
            settingsVC.modalPresentationStyle = .fullScreen
            self.show(settingsVC, sender: self)
        }
        else if (email != "") {
            db.collection("UserData").whereField("email", isEqualTo: email).getDocuments(completion: {obj, error in
                guard let docs = obj?.documents else {
                    return
                }
                if docs.count > 0 {
                    self.userData = UserData(dictionary: docs[0].data())
                }
                settingsVC.userData = self.userData
                settingsVC.modalPresentationStyle = .fullScreen
                self.show(settingsVC, sender: self)
            })
        }
        else {
            settingsVC.modalPresentationStyle = .fullScreen
            self.show(settingsVC, sender: self)
        }
    }
    
    // for button when not signed in
    @objc func settingsButtonTapped(_ sender: UITapGestureRecognizer) {
        let settingsVC = storyboard?.instantiateViewController(identifier: "settingsVC") as! SettingsVC
        
        let email = Auth.auth().currentUser?.email ?? ""
        
        if userData != nil {
            settingsVC.userData = userData
            settingsVC.modalPresentationStyle = .fullScreen
            self.show(settingsVC, sender: self)
        }
        else if (email != "") {
            db.collection("UserData").whereField("email", isEqualTo: email).getDocuments(completion: {obj, error in
                guard let docs = obj?.documents else {
                    return
                }
                if docs.count > 0 {
                    self.userData = UserData(dictionary: docs[0].data())
                }
                settingsVC.userData = self.userData
                settingsVC.modalPresentationStyle = .fullScreen
                self.show(settingsVC, sender: self)
            })
        }
        else {
            settingsVC.modalPresentationStyle = .fullScreen
            self.show(settingsVC, sender: self)
        }
    }

}
