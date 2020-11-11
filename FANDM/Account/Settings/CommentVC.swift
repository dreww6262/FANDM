//
//  CommentVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/11/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {
    
    let emailTextField = UITextField()
    let commentTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.systemGray6
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 22) as Any]
        navBar?.isHidden = false
        title = "Leave Comment"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navBar?.backItem?.backBarButtonItem = backItem
        
        view.backgroundColor = .white
        
        let adjustment = 22.5 + (navBar?.frame.height ?? 0) + (tabBarController?.tabBar.frame.height ?? 0) / 2
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.text = "Include your email if you would like for us to get back to you."
        emailLabel.font = UIFont(name: "Poppins", size: 16)
        emailLabel.textColor = .black
        emailLabel.frame = CGRect(x: 20, y: view.frame.height / 4 - adjustment, width: view.frame.width - 40, height: 45)
        emailLabel.lineBreakMode = .byWordWrapping
        emailLabel.numberOfLines = 0
        
        
        
    }
    
}
