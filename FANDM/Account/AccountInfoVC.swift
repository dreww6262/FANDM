//
//  AccountInfoVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 10/19/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class AccountInfoVC: UIViewController {
    
    let cardView = UIImageView()
    let visitLabel = UILabel()
    let checkPointIndicator = UIView()
    let progressBar = UIView()
    let infoBox = UIView()
    let recordVisitButton = UIButton()
    let redeemButton = UIButton()
    let infoLabel = UILabel()
    var circles = [UIView]()
    
    var userData: UserData?
    var currentCard: PunchCard?
    
    let db = Firestore.firestore()
    
    
    let numChunks = 5
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardView)
        view.addSubview(visitLabel)
        view.addSubview(checkPointIndicator)
        view.addSubview(recordVisitButton)
        view.addSubview(redeemButton)
        view.addSubview(progressBar)
        view.addSubview(infoBox)
        infoBox.addSubview(infoLabel)
        
        var count = 0
        while count <= numChunks {
            let circle = UIView()
            circles.append(circle)
            view.addSubview(circle)
            count += 1
        }
        
        cardView.image = UIImage(named: "card")
        
        view.backgroundColor = .white
        
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil) {
            dismiss(animated: false, completion: nil)
        }
        
        // #407586 -- blue
        // #C25134 -- orange
        // #632E3C -- maroon
        let colors: [UIColor] = [UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00), UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.00), UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)]
        
        let positionIndex = self.currentCard?.index ?? 0 // will set with punchcard
        var count = 0
        for circle in circles {
            if (count < positionIndex) {
                circle.backgroundColor = colors[count % 3]
            }
            else {
                circle.backgroundColor = .lightGray
            }
            count += 1
        }
        infoBox.backgroundColor = colors[positionIndex % 3]
        infoLabel.text = "You only have \(6 - positionIndex) visits left to redeem your reward!"
        setup()
    }
    
    
    
    func setup() {
        navigationController?.navigationBar.tintColor = .white
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.shadowImage = UIImage()
        navBar?.barTintColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        navBar?.isHidden = false
        
        cardView.frame = CGRect(x: 20, y: 16, width: view.frame.width - 40, height: 0.65 * (view.frame.width - 40))
        cardView.layer.cornerRadius = 5
        cardView.clipsToBounds = true
        
        db.collection("UserData").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments(completion: {
            obj, error in
            guard let docs = obj?.documents else {
                return
            }
            if (docs.count > 0) {
                self.userData = UserData(dictionary: docs[0].data())
            }
            else {
                let alert = UIAlertController(title: "Could not pull userdata.  Signing you out.", message: "If this persists, make a new account.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                do {
                    try(Auth.auth().signOut())
                    self.dismiss(animated: false, completion: nil)
                    return
                }
                catch {
                    print(error.localizedDescription)
                    self.dismiss(animated: false, completion: nil)
                    return
                }                
            }
            self.db.collection("PunchCard").whereField("username", isEqualTo: self.userData!.username).getDocuments(completion: { obj, error in
                guard let docs = obj?.documents else {
                    return
                }
                for doc in docs {
                    let newPunch = PunchCard(dictionary: doc.data())
                    if newPunch.dateRedeemed == nil {
                        self.currentCard = newPunch
                    }
                }
                if self.currentCard == nil {
                    let doc = self.db.collection("PunchCard").document()
                    self.currentCard = PunchCard(username: self.userData!.username, index: 0, dateCreated: Date(), dateRedeemed: nil, docID: doc.documentID)
                    doc.setData(self.currentCard!.dictionary)
                }
                self.populateData()
            })
        })
    }
    
    func populateData() {
        visitLabel.text = "Your Visits: \(self.currentCard?.index ?? 0)"
        visitLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
        visitLabel.sizeToFit()
        visitLabel.frame = CGRect(x: 20, y: cardView.frame.maxY + 24, width: visitLabel.frame.width, height: visitLabel.frame.height)
        
        progressBar.frame = CGRect(x: 20, y: visitLabel.frame.maxY + 24, width: view.frame.width - 40, height: 6)
        progressBar.layer.cornerRadius = 3
        progressBar.layer.masksToBounds = true
        progressBar.backgroundColor = .darkGray
        
        var count = 0
        let chunkSize = (progressBar.frame.width - 40.0) / CGFloat(numChunks)
        let dotSize: CGFloat = 20
        let yOffsetOfDot = progressBar.frame.midY - dotSize/2
        let xStart = progressBar.frame.minX + 20 - dotSize/2
        
        // #407586 -- blue
        // #C25134 -- orange
        // #632E3C -- maroon
        let colors: [UIColor] = [UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00), UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.00), UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)]
        
        let positionIndex = self.currentCard?.index ?? 0 // will set with punchcard
        while count <= numChunks {

            circles[count].frame = CGRect(x: xStart + (CGFloat(count) * chunkSize), y: yOffsetOfDot, width: dotSize, height: dotSize)
            circles[count].layer.cornerRadius = dotSize/2
            if (count < positionIndex) {
                circles[count].backgroundColor = colors[count % 3]
            }
            else {
                circles[count].backgroundColor = .lightGray
            }
            count += 1
        }
        
        infoBox.frame = CGRect(x: 20, y: progressBar.frame.maxY + 24, width: view.frame.width - 40, height: 80)
        infoBox.backgroundColor = colors[positionIndex % 3]
        infoBox.layer.cornerRadius = 10
        infoBox.clipsToBounds = true
        
        infoLabel.frame = CGRect(x: 10, y: 10, width: infoBox.frame.width - 20, height: infoBox.frame.height - 20)
        infoLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        
        if positionIndex < numChunks + 1 {
            infoLabel.text = "You only have \(6 - positionIndex) visits left to redeem your reward!"
            checkPointIndicator.frame = CGRect(x: circles[positionIndex].frame.minX, y: infoBox.frame.minY - dotSize/2, width: dotSize, height: dotSize)
        }
        else {
            infoLabel.text = "Redeem your reward now by tapping the \"Redeem Reward\" button below!"
            checkPointIndicator.isHidden = true
        }
        checkPointIndicator.layer.cornerRadius = dotSize
        checkPointIndicator.backgroundColor = colors[positionIndex % 3]
        
        // 2 * buttonsize + spacing
        let yButton = (infoBox.frame.maxY + view.frame.height) / 2 - 54
        recordVisitButton.setTitle("Record Visit", for: .normal)
        recordVisitButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        recordVisitButton.setTitleColor(.white, for: .normal)
        recordVisitButton.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        recordVisitButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: yButton, width: 280, height: 45)
        recordVisitButton.layer.cornerRadius = 22
        recordVisitButton.clipsToBounds = true
        recordVisitButton.isUserInteractionEnabled = true
        recordVisitButton.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        
        redeemButton.setTitle("Redeem Reward", for: .normal)
        redeemButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        redeemButton.addTarget(self, action: #selector(redeemPressed), for: .touchUpInside)
        
        if (positionIndex >= 6) {
            redeemButton.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
            redeemButton.setTitleColor(.white, for: .normal)
            redeemButton.isUserInteractionEnabled = true
        }
        else {
            redeemButton.backgroundColor = .lightGray
            redeemButton.setTitleColor(.black, for: .normal)
            redeemButton.isUserInteractionEnabled = true
        }
        redeemButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: recordVisitButton.frame.maxY + 18, width: 280, height: 45)
        redeemButton.layer.cornerRadius = 22
        redeemButton.clipsToBounds = true
        redeemButton.isUserInteractionEnabled = true
    }
    
    @objc func redeemPressed(_ sender: UITapGestureRecognizer) {
        let redeemVC = RedeemVC()
        redeemVC.punchCard = currentCard
        self.show(redeemVC, sender: self)
    }
    
    @objc func recordPressed(_ sender: UITapGestureRecognizer) {
        if currentCard!.index > 5 {
            let alert = UIAlertController(title: "Redeem your reward before recording a new visit.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let recordVC = RecordVisitVC()
            recordVC.punchCard = currentCard
            show(recordVC, sender: self)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Something Else"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
}
