//
//  RedeemVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/9/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class RedeemVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return redeemableList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return redeemableList[row]
    }
    
    var redeemableList = [String]()
    var punchCard: PunchCard?
    let picker = UIPickerView()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Poppins-SemiBold", size: 28) as Any]
        navBar?.barTintColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        navBar?.isHidden = false
        title = "Redeem Reward"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navBar?.backItem?.backBarButtonItem = backItem
        
        view.backgroundColor = .white
        
        picker.delegate = self
        picker.dataSource = self
        
        redeemableList.append("Select an Offer")
        db.collection("Redeemables").getDocuments(completion: {obj, error in
            guard let docs = obj?.documents else {
                let alert = UIAlertController(title: "Could not get offers.", message: "Try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            for doc in docs {
                self.redeemableList.append(doc.get("offer") as! String)
            }
            self.picker.reloadAllComponents()
        })
        
        view.addSubview(picker)
        picker.frame = CGRect(x: 20, y: view.frame.height/7, width: view.frame.width - 40, height: view.frame.height / 3)
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 10
        picker.clipsToBounds = true
        
        let redeemButton = UIButton()
        view.addSubview(redeemButton)
        redeemButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: view.frame.height * 2 / 3, width: 280, height: 45)
        redeemButton.setTitle("Redeem", for: .normal)
        redeemButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        redeemButton.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        redeemButton.layer.borderWidth = 2
        redeemButton.layer.borderColor = UIColor.white.cgColor
        redeemButton.clipsToBounds = true
        redeemButton.layer.cornerRadius = 22
        redeemButton.addTarget(self, action: #selector(redeemPressed), for: .touchUpInside)
        
    }
    
    @objc func redeemPressed(_ sender: UITapGestureRecognizer) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        if (selectedRow == 0) {
            let alert = UIAlertController(title: "Please select an offer to redeem", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let dateRedeemed = Date()
            db.collection("Redemptions").document().setData(["username": punchCard!.username, "dateRedeemed": dateRedeemed, "offer": redeemableList[selectedRow], "email": Auth.auth().currentUser?.email ?? "no email, check UserData", "punchCardID": punchCard!.docID])
            punchCard?.dateRedeemed = dateRedeemed
            db.collection("PunchCard").document(punchCard!.docID).setData(punchCard!.dictionary) { _ in
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}
