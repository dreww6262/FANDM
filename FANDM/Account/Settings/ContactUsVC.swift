//
//  ContactUsVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/11/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.systemGray6
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 28) as Any]
        navBar?.isHidden = false
        title = "Contact Us"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navBar?.backItem?.backBarButtonItem = backItem
        
        view.backgroundColor = .white
        
        let adjustment = 22.5 + (navBar?.frame.height ?? 0) + (tabBarController?.tabBar.frame.height ?? 0) / 2
        
        let fandmButton = UIButton()
        view.addSubview(fandmButton)
        fandmButton.setTitle("Contact First & Main", for: .normal)
        fandmButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        fandmButton.frame = CGRect(x: 20, y: (view.frame.height / 4) - adjustment, width: view.frame.width - 40, height: 45)
        fandmButton.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        fandmButton.setTitleColor(.white, for: .normal)
        fandmButton.tintColor = .clear
        fandmButton.addTarget(self, action: #selector(handleFMTap), for: .touchUpInside)
        fandmButton.layer.cornerRadius = 22
        
        let prismButton = UIButton()
        view.addSubview(prismButton)
        prismButton.setTitle("Contact VT PRISM", for: .normal)
        prismButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        prismButton.frame = CGRect(x: 20, y: (view.frame.height / 2) - adjustment, width: view.frame.width - 40, height: 45)
        prismButton.backgroundColor = UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.00)
        prismButton.setTitleColor(.white, for: .normal)
        prismButton.tintColor = .clear
        prismButton.addTarget(self, action: #selector(handlePrismTap), for: .touchUpInside)
        prismButton.layer.cornerRadius = 22
        
        let drewButton = UIButton()
        view.addSubview(drewButton)
        drewButton.setTitle("Contact the Developer", for: .normal)
        drewButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        drewButton.frame = CGRect(x: 20, y: (view.frame.height * 3 / 4) - adjustment, width: view.frame.width - 40, height: 45)
        drewButton.backgroundColor = UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00)
        drewButton.setTitleColor(.white, for: .normal)
        drewButton.tintColor = .clear
        drewButton.addTarget(self, action: #selector(handleDrewTap), for: .touchUpInside)
        drewButton.layer.cornerRadius = 22

        // Do any additional setup after loading the view.
    }
    
    @objc func handleFMTap(_ sender: UITapGestureRecognizer) {
        let url = URL(string: "https://www.firstandmainblacksburg.com/contact")
        if (url != nil) {
            UIApplication.shared.open(url!)
        }
        else {
            let alert = UIAlertController(title: "Unable to open link", message: "Try again or come back later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: false)
        }
    }
    
    @objc func handlePrismTap(_ sender: UITapGestureRecognizer) {
        let url = URL(string: "https://www.vtprism.com/contact-us")
        if (url != nil) {
            UIApplication.shared.open(url!)
        }
        else {
            let alert = UIAlertController(title: "Unable to open link", message: "Try again or come back later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: false)
        }
    }
    
    @objc func handleDrewTap(_ sender: UITapGestureRecognizer) {
        let url = URL(string: "https://www.linkedin.com/in/andrew-williamson-0703a279/")
        if (url != nil) {
            UIApplication.shared.open(url!)
        }
        else {
            let alert = UIAlertController(title: "Unable to open link", message: "Try again or come back later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: false)
        }
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
