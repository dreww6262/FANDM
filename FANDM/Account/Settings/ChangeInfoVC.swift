//
//  ChangeInfoVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/8/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class ChangeInfoVC: UIViewController {
    
    var userData: UserData?
    let db = Firestore.firestore()
    
    var type: String?
    let edit1 = UITextField()
    let edit2 = UITextField()
    let edit3 = UITextField()
    let edit4 = UITextField()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        let currentUser = Auth.auth().currentUser
        
        if (userData == nil) {
            db.collection("UserData").whereField("email", isEqualTo: currentUser?.email ?? "").getDocuments(completion: {obj, error in
                guard let docs = obj?.documents else {
                    return
                }
                if (docs.count > 0) {
                    self.userData = UserData(dictionary: docs.first!.data())
                }
            })
        }
        
        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        
        
        view.addSubview(edit1)
        view.addSubview(edit2)
        view.addSubview(edit3)
        view.addSubview(edit4)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
                
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        
        edit1.textColor = .white
        edit1.font = UIFont(name: "Poppins", size: 16)
        edit2.textColor = .white
        edit2.font = UIFont(name: "Poppins", size: 16)
        edit3.textColor = .white
        edit3.font = UIFont(name: "Poppins", size: 16)
        edit4.textColor = .white
        edit4.font = UIFont(name: "Poppins", size: 16)
        
        edit1.frame = CGRect(x: 20, y: view.frame.height/4, width: view.frame.width - 40, height: 20)
        edit2.frame = CGRect(x: 20, y: edit1.frame.maxY + 32, width: view.frame.width - 40, height: 20)
        edit3.frame = CGRect(x: 20, y: edit2.frame.maxY + 32, width: view.frame.width - 40, height: 20)
        edit4.frame = CGRect(x: 20, y: edit3.frame.maxY + 32, width: view.frame.width - 40, height: 20)
        
        cancelButton.frame = CGRect(x: 20, y: view.frame.height * 3 / 5, width: view.frame.width - 40, height: 45)
        cancelButton.layer.cornerRadius = 22
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.clipsToBounds = true
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelPressed))
        cancelButton.addGestureRecognizer(cancelTap)
        
        saveButton.frame = CGRect(x: 20, y: cancelButton.frame.maxY + 8, width: view.frame.width - 40, height: 45)
        saveButton.layer.cornerRadius = 22
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00), for: .normal)
        saveButton.clipsToBounds = true
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(savePressed))
        saveButton.addGestureRecognizer(saveTap)
        
        createBottomLine(forInput: edit1)
        createBottomLine(forInput: edit2)
        createBottomLine(forInput: edit3)
        createBottomLine(forInput: edit4)

        switch type {
        case "Name":
            edit1.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            edit1.text = currentUser?.displayName
            edit2.isHidden = true
            edit3.isHidden = true
            edit4.isHidden = true
            
        case "Email":
            edit1.attributedPlaceholder = NSAttributedString(string: "Current Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            edit1.text = currentUser?.email
            
            edit2.attributedPlaceholder = NSAttributedString(string: "New Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            edit3.attributedPlaceholder = NSAttributedString(string: "Confirm Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            edit4.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            edit4.isSecureTextEntry = true
        
        default:
            edit1.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            edit1.isSecureTextEntry = true
            
            edit2.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            edit2.isSecureTextEntry = true
            
            edit3.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            edit3.isSecureTextEntry = true
            
            edit4.isHidden = true
        }
        
    }
    
    func createBottomLine(forInput: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: 22, width: forInput.frame.width, height: 2.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        forInput.borderStyle = UITextField.BorderStyle.none
        forInput.layer.addSublayer(bottomLine)
    }
    
    @objc func savePressed(_ sender: UITapGestureRecognizer) {
        
        let dispatch = DispatchGroup()
        dispatch.enter()
        
        var shouldDismiss = true
        
        if (edit1.text == nil || edit1.text == "") {
            let alert = UIAlertController(title: "You need to fill out the first field", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            dispatch.leave()
            return
        }
        
        if (type != "Name") {
            if (edit2.text == nil || edit2.text == "" || edit3.text == nil || edit3.text == "") {
                let alert = UIAlertController(title: "You need to fill out all fields", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                dispatch.leave()
                return
            }
            
            else if (edit2.text != edit3.text) {
                let alert = UIAlertController(title: "The second and third fields do not match.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                dispatch.leave()
                return
            }
        }
        
        switch type {
        case "Name":
            let editableUser = Auth.auth().currentUser?.createProfileChangeRequest()
            editableUser?.displayName = edit1.text
            editableUser?.commitChanges(completion: { error in
                if error != nil {
                    let alert = UIAlertController(title: "Could not update display name.", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    shouldDismiss = false
                }
                else {
                    let split = self.edit1.text!.split(separator: " ")
                    self.userData?.firstName = String(split[0])
                    var lastName = ""
                    var count = 0
                    while count < split.count {
                        if count == 0 {
                            continue
                        }
                        lastName += split[count]
                        if (count != split.count - 1) {
                            lastName += " "
                        }
                        count += 1
                    }
                    self.userData?.lastName = lastName
                    self.db.document(self.userData!.docID).setData(self.userData!.dictionary)
                }
                dispatch.leave()
            })
                
        case "Email":
            let credential = EmailAuthProvider.credential(withEmail: edit1.text!, password: edit4.text!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
                if error != nil {
                    print("firebase password reauthentication error: \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Your current email or password is incorrect.", message: "Please input your correct current credentials.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    shouldDismiss = false
                }
                else {
                    Auth.auth().currentUser?.updateEmail(to: self.edit2.text!, completion: { error in
                        if error != nil {
                            print("firebase email error: \(error!.localizedDescription)")
                            let alert = UIAlertController(title: "Invalid email", message: "Please input a valid email that is not being used by another account.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            shouldDismiss = false
                        }
                        self.userData?.email = self.edit2.text!.lowercased()
                        self.db.collection("UserData").document(self.userData!.docID).setData(self.userData!.dictionary)
                        dispatch.leave()
                    })
                }
            })
            
        default:
            let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
            let __passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            if (__passwordPredicate.evaluate(with: edit2.text!)) {
                let alert = UIAlertController(title: "Password must be minimum of 8 characters, at least 1 uppercase letter, 1 lowercase letter, and 1 number.", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                dispatch.leave()
                return
            }
            
            let credential = EmailAuthProvider.credential(withEmail: Auth.auth().currentUser!.email!, password: edit1.text!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
                if (error != nil) {
                    print("firebase password reauthentication error: \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Your current password is incorrect.", message: "Please input your correct current password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    shouldDismiss = false
                }
                else {
                    Auth.auth().currentUser?.updatePassword(to: self.edit2.text!, completion: { error in
                        if error != nil {
                            print("firebase password error: \(error!.localizedDescription)")
                            let alert = UIAlertController(title: "Invalid password", message: "Please input a valid password.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            shouldDismiss = false
                        }
                        dispatch.leave()
                    })
                }
            })
            
        }
        dispatch.notify(queue: .main) {
            if (shouldDismiss) {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc func cancelPressed(_ sender: UITapGestureRecognizer) {
        edit1.text = ""
        edit2.text = ""
        edit3.text = ""
        self.dismiss(animated: false, completion: nil)
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
