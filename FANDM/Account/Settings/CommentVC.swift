//
//  CommentVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/11/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class CommentVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let emailTextField = UITextField()
    let commentTextView = UITextView()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.tintColor = .black
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.systemGray6
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 22) as Any]
        navBar?.isHidden = false
        title = "Leave Comment"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navBar?.backItem?.backBarButtonItem = backItem
        
        view.backgroundColor = UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00)
        
        var adjustment = 22.5 + (navBar?.frame.height ?? 0)
        adjustment += (tabBarController?.tabBar.frame.height ?? 0) / 2
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.text = "Include your email if you would like for us to get back to you."
        emailLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        emailLabel.textColor = .white
        emailLabel.frame = CGRect(x: 20, y: view.frame.height / 4 - adjustment, width: view.frame.width - 40, height: 45)
        emailLabel.lineBreakMode = .byWordWrapping
        emailLabel.numberOfLines = 0
        emailLabel.textAlignment = .center
        
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.text = Auth.auth().currentUser?.email ?? ""
        emailTextField.frame = CGRect(x: 20, y: emailLabel.frame.maxY + 16, width: view.frame.width - 40, height: 20)
        emailTextField.font = UIFont(name: "Poppins", size: 16)
        createBottomLine(forInput: emailTextField)
        emailTextField.textColor = .white
        
        commentTextView.delegate = self
        view.addSubview(commentTextView)
        //commentTextView.attributedPlaceholder = NSAttributedString(string: "What's on your mind?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        commentTextView.frame = CGRect(x: 20, y: emailTextField.frame.maxY + 32, width: view.frame.width - 40, height: view.frame.height / 3)
        commentTextView.font = UIFont(name: "Poppins", size: 16)
        commentTextView.text = "What's on your mind?"
        commentTextView.textColor = UIColor.darkGray
        commentTextView.backgroundColor = .systemGray2
        commentTextView.layer.cornerRadius = 10
        commentTextView.clipsToBounds = true
        commentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let submitButton = UIButton()
        view.addSubview(submitButton)
        submitButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: commentTextView.frame.maxY + 32, width: 280, height: 45)
        submitButton.layer.cornerRadius = 22
        submitButton.clipsToBounds = true
        submitButton.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.tintColor = .clear
        submitButton.addTarget(self, action: #selector(handleSubmitTap), for: .touchUpInside)
        submitButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        
    }
    
    @objc func handleSubmitTap(_ sender: UITapGestureRecognizer) {
        if commentTextView.text == nil || commentTextView.text == "" {
            let alert = UIAlertController(title: "Please add a comment to submit.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            db.collection("Comments").document().setData(["email": emailTextField.text ?? "", "comment": commentTextView.text!, "date": Date()])
            navigationController?.popViewController(animated: true)
        }
    }
    
    func createBottomLine(forInput: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 22, width: forInput.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        forInput.borderStyle = UITextField.BorderStyle.none
        forInput.layer.addSublayer(bottomLine)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    @objc func DismissKeyboard(){
    //Causes the view to resign from the status of first responder.
    view.endEditing(true)
    }
    
    
}
