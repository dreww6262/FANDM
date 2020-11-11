//
//  SettingsVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/4/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase
import QuickTableViewController

class SettingsVC: QuickTableViewController {
    
    let myAccountArray = ["Name", "Email", "Password"]
    let services = ["Terms of Service", "Privacy Policy", "Leave a Comment", "Contact Us"]
    let accountActions = ["Log Out", "Delete Account"]
    
    var userData: UserData?
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.systemGray6
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.isHidden = false
        title = "Settings"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navBar?.backItem?.backBarButtonItem = backItem
        
        let user = Auth.auth().currentUser
        let passwordDetailText = { () -> String in
            if (user == nil) {
                return "Not Signed In"
            }
            return ""
        }()
        
        tableContents = [
            Section(title: "My Account", rows: [
                NavigationRow(text: "Name", detailText: .value1(user?.displayName ?? "Not Signed In"), icon: .named("user"), action: didToggleSelection()),
                NavigationRow(text: "Email", detailText: .value1(user?.email ?? "Not Signed In"), icon: .named("email"), action: didToggleSelection()),
                NavigationRow(text: "Change Password", detailText: .value1(passwordDetailText), icon: .named("user"), action: didToggleSelection())]),
            Section(title: "Support", rows: [
                NavigationRow(text: "Terms of Service", detailText: .value1(""), icon: .named("document"), action: nil),
                NavigationRow(text: "Privacy Policy", detailText: .value1(""), icon: .named("document"), action: nil),
                NavigationRow(text: "Leave a Comment", detailText: .value1(""), icon: .none, action: didToggleSelection()),
                NavigationRow(text: "Contact Us", detailText: .value1(""), icon: .none, action: didToggleSelection())]),
            Section(title: "Account Actions", rows: [
                NavigationRow(text: "Sign Out", detailText: .value1(passwordDetailText), icon: .none, action: didToggleSelection()),
                NavigationRow(text: "Delete Account", detailText: .value1(passwordDetailText), icon: .none, action: didToggleSelection())])
        ]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        let passwordDetailText = { () -> String in
            if (user == nil) {
                return "Not Signed In"
            }
            return ""
        }()
        
        if user != nil {
            tableContents = [
                Section(title: "My Account", rows: [
                    NavigationRow(text: "Name", detailText: .value1(user?.displayName ?? "Not Signed In"), icon: .named("user"), action: didToggleSelection()),
                    NavigationRow(text: "Email", detailText: .value1(user?.email ?? "Not Signed In"), icon: .named("email"), action: didToggleSelection()),
                    NavigationRow(text: "Change Password", detailText: .value1(passwordDetailText), icon: .named("user"), action: didToggleSelection())]),
                Section(title: "Support", rows: [
                    NavigationRow(text: "Terms of Service", detailText: .value1(""), icon: .named("document"), action: nil),
                    NavigationRow(text: "Privacy Policy", detailText: .value1(""), icon: .named("document"), action: nil),
                    NavigationRow(text: "Leave a Comment", detailText: .value1(""), icon: .none, action: didToggleSelection()),
                    NavigationRow(text: "Contact Us", detailText: .value1(""), icon: .none, action: didToggleSelection())]),
                Section(title: "Account Actions", rows: [
                    NavigationRow(text: "Sign Out", detailText: .value1(passwordDetailText), icon: .none, action: didToggleSelection()),
                    NavigationRow(text: "Delete Account", detailText: .value1(passwordDetailText), icon: .none, action: didToggleSelection())])
            ]
        }
        else {
            tableContents = [
                Section(title: "My Account", rows: [
                    NavigationRow(text: "Name", detailText: .value1(user?.displayName ?? "Not Signed In"), icon: .named("user"), action: nil),
                    NavigationRow(text: "Email", detailText: .value1(user?.email ?? "Not Signed In"), icon: .named("email"), action: nil),
                    NavigationRow(text: "Change Password", detailText: .value1(passwordDetailText), icon: .named("user"), action: nil)]),
                Section(title: "Support", rows: [
                    NavigationRow(text: "Terms of Service", detailText: .value1(""), icon: .named("document"), action: nil),
                    NavigationRow(text: "Privacy Policy", detailText: .value1(""), icon: .named("document"), action: nil),
                    NavigationRow(text: "Leave a Comment", detailText: .value1(""), icon: .none, action: didToggleSelection()),
                    NavigationRow(text: "Contact Us", detailText: .value1(""), icon: .none, action: didToggleSelection())]),
                Section(title: "Account Actions", rows: [
                    NavigationRow(text: "Sign Out", detailText: .value1(passwordDetailText), icon: .none, action: nil),
                    NavigationRow(text: "Delete Account", detailText: .value1(passwordDetailText), icon: .none, action: nil)])
            ]
        }
    }
    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] row in
            if row.text == "Name" || row.text == "Email" || row.text == "Change Password" {
                let changeVC = ChangeInfoVC()
                changeVC.type = row.text
                changeVC.modalPresentationStyle = .fullScreen
                changeVC.modalTransitionStyle = .flipHorizontal
                self?.present(changeVC, animated: false, completion: nil)
            }
            
            else if row.text == "Terms of Service" {
                
            }
            
            else if row.text == "Privacy Policy" {
                
            }
            
            else if row.text == "Leave a Comment" {
                self?.show(CommentVC(), sender: self)
            }
            
            else if row.text == "Contact Us" {
                self?.show(ContactUsVC(), sender: self)
            }
            
            else if row.text == "Sign Out" {
                
                let areYouSure = UIAlertController(title: "Are you sure you want to sign out?", message: nil, preferredStyle: .alert)
                areYouSure.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                    do {
                        try(Auth.auth().signOut())
                        self?.navigationController?.popViewController(animated: false)
                    }
                    catch {
                        let alert = UIAlertController(title: "Uh Oh...", message: "Looks like we were unable to sign you out... Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default))
                        self?.present(alert, animated: true)
                    }
                }))
                areYouSure.addAction(UIAlertAction(title: "Stay signed in", style: .cancel, handler: nil))
                self?.present(areYouSure, animated: true, completion: nil)
                
            }
            
            else if row.text == "Delete Account" {
                let areYouSure = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
                areYouSure.addTextField(configurationHandler: {textField in
                    textField.placeholder = "password"
                    textField.isSecureTextEntry = true
                })
                areYouSure.addAction(UIAlertAction(title: "Delete Account", style: .default, handler: {_ in
                    let credential = EmailAuthProvider.credential(withEmail: Auth.auth().currentUser!.email!, password: areYouSure.textFields!.first!.text!)
                    Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
                        if error == nil {
                            self?.db.collection("PunchCard").whereField("username", isEqualTo: self!.userData!.username).getDocuments(completion: { obj, error in
                                guard let docs = obj?.documents else {
                                    let alert = UIAlertController(title: "Uh Oh...", message: "Looks like we were unable to sign you out... Please try again.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                                    self?.present(alert, animated: true)
                                    return
                                }
                                for doc in docs {
                                    doc.reference.delete()
                                }
                                self?.db.collection("UserData").whereField("username", isEqualTo: self!.userData!.username).getDocuments(completion: { obj, error in
                                    guard let docs = obj?.documents else {
                                        let alert = UIAlertController(title: "Uh Oh...", message: "Looks like we were unable to sign you out... Please try again.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Okay", style: .default))
                                        self?.present(alert, animated: true)
                                        return
                                    }
                                    for doc in docs {
                                        doc.reference.delete()
                                    }
                                    Auth.auth().currentUser?.delete(completion: {error in
                                        if error != nil {
                                            let alert = UIAlertController(title: "Uh Oh...", message: "Looks like we were unable to sign you out... Please try again.", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Okay", style: .default))
                                            self?.present(alert, animated: true)
                                            return
                                        }
                                        else {
                                            self?.navigationController?.popViewController(animated: false)
                                        }
                                    })
                                })
                            })
                        }
                        else {
                            let alert = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    })
                }))
                areYouSure.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(areYouSure, animated: true, completion: nil)
            }
            
            else {
                print("bad row: \(row.text)")
            }
        }
    }
    
}
