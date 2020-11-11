//
//  StoreItemDetailsVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class StoreItemDetailsVC: UIViewController {

    let navBar = UIView()
    let backButton = UIButton()
    let bannerImage = UIImageView()
    let titleText = UILabel()
    let favButton = UIButton()
    let descriptionText = UILabel()
    
    let buttonBar = UIView()
    let phoneButton = UIButton()
    let websiteButton = UIButton()
    let directionsButton = UIButton()
    
    var store: Store?
    var userData: UserData?
    var userDataRef: DocumentReference?
    
    let db = Firestore.firestore()
    
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        store?.views += 1
        db.collection("Stores").getDocuments(completion: {obj, error in
            if (error == nil) {
                for doc in obj!.documents {
                    if (doc.get("name") as? String == self.store?.name) {
                        doc.reference.setData(self.store!.dictionary)
                    }
                }
            }
        })
        
        view.addSubview(navBar)
        view.backgroundColor = .white
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        navBar.addSubview(backButton)
        backButton.frame = CGRect(x: 10, y: navBar.frame.midY, width: 75, height: 20)
        backButton.titleLabel?.textAlignment = .left
        backButton.setTitle(" Stores", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        //backButton.titleLabel?.textColor = .black
        backButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.backgroundColor = .clear
        backButton.tintColor = .clear
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backPressed))
        backButton.addGestureRecognizer(backTap)
        
        
        
        view.addSubview(scrollView)
        view.bringSubviewToFront(navBar)
        scrollView.addSubview(contentView)
        scrollView.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.height - 80)
        contentView.frame = scrollView.bounds
        scrollView.contentSize = contentView.bounds.size
        
        contentView.addSubview(bannerImage)
        contentView.addSubview(titleText)
        contentView.addSubview(favButton)
        contentView.addSubview(descriptionText)
        
        
        
        bannerImage.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: view.frame.height/3)
        
        let url = URL(string: store!.imageLink)
        if (url != nil) {
            bannerImage.sd_setImage(with: url!, completed: { _,error,_,_  in
                if (error != nil) {
                    self.bannerImage.image = UIImage(named: "firstandmaindefault")
                }
            })
        }
        else {
            bannerImage.image = UIImage(named: "firstandmaindefault")
        }
        bannerImage.contentMode = .scaleAspectFit
        bannerImage.clipsToBounds = true
        
        setUpButtonBar()
        
        titleText.text = store!.name
        titleText.font = UIFont(name: "Poppins-SemiBold", size: 18)
        titleText.sizeToFit()
        titleText.frame = CGRect(x: 20, y: buttonBar.frame.maxY + 32, width: titleText.frame.width, height: titleText.frame.height)
        
        favButton.frame = CGRect(x: titleText.frame.maxX + 16, y: titleText.frame.midY - (titleText.frame.height/2), width: titleText.frame.height, height: titleText.frame.height)
        favButton.backgroundColor = .clear
        favButton.tintColor = .clear
        if (userData != nil && userData!.favoriteStores.contains(store!.name)) {
            favButton.setImage(UIImage(named: "curvedfilled"), for: .normal)
        }
        else {
            favButton.setImage(UIImage(named: "curvedempty"), for: .normal)
        }
        let favTap = UITapGestureRecognizer(target: self, action: #selector(handleFavButton))
        favButton.addGestureRecognizer(favTap)
        
        descriptionText.frame = CGRect(x: 20, y: titleText.frame.maxY + 16, width: view.frame.width - 40, height: 1000)
        descriptionText.text = store!.description
        descriptionText.font = UIFont(name: "Poppins", size: 14)
        descriptionText.numberOfLines = 0
        descriptionText.sizeToFit()
        
        
        if (descriptionText.frame.maxY > contentView.frame.height - 16) {
            contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: descriptionText.frame.maxY + 16)
            scrollView.contentSize = contentView.bounds.size
        }
        
        


        // Do any additional setup after loading the view.
    }
    
    @objc func backPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func openInSafari(_ sender: UITapGestureRecognizer) {
        //code is legit... just need to refactor backend
        
        let url = URL(string: store!.website)
        if (url != nil) {
            UIApplication.shared.open(url!)
        }
        else {
            let alert = UIAlertController(title: "Unable to open link", message: "Try again or come back later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: false)
        }
        
    }
    
    @objc func makePhoneCall(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "tel://\(store!.phone)") {
             UIApplication.shared.open(url)
         }
        else {
            let alert = UIAlertController(title: "Unable to make phone call", message: "Try again or come back later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: false)
        }
    }
    
    @objc func giveDirections(_ sender: UITapGestureRecognizer) {
        let coordinates = CLLocationCoordinate2DMake(store!.lat, store!.long)
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapItem.name = store!.name
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    @objc func handleFavButton(_ sender: UITapGestureRecognizer) {
        
        if (userData == nil) {
            let alert = UIAlertController(title: "Not Signed In", message: "Sign in to mark your favorite stores!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if (userData!.favoriteStores.contains(store!.name)) {
            userData?.favoriteStores.removeAll(where: { string in
                return string == store!.name
            })
            favButton.setImage(UIImage(named: "curvedempty"), for: .normal)
        }
        else {
            userData?.favoriteStores.append(store!.name)
            favButton.setImage(UIImage(named: "curvedfilled"), for: .normal)
        }
        userDataRef?.setData(userData!.dictionary)
    }
    
    func setUpButtonBar() {
        contentView.addSubview(buttonBar)
        buttonBar.addSubview(websiteButton)
        buttonBar.addSubview(phoneButton)
        buttonBar.addSubview(directionsButton)
        
        buttonBar.frame = CGRect(x: bannerImage.frame.minX, y: bannerImage.frame.maxY + 8, width: bannerImage.frame.width, height: 30)
        
        websiteButton.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        phoneButton.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        directionsButton.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        
        websiteButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        phoneButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        directionsButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        
        websiteButton.frame = CGRect(x: 0, y: 0, width: (buttonBar.frame.width - 16)/3, height: buttonBar.frame.height)
        phoneButton.frame = CGRect(x: websiteButton.frame.maxX + 8, y: 0, width: (buttonBar.frame.width - 16) / 3, height: buttonBar.frame.height)
        directionsButton.frame = CGRect(x: phoneButton.frame.maxX + 8, y: 0, width: (buttonBar.frame.width - 16) / 3, height: buttonBar.frame.height)
        
        websiteButton.setTitle("Website", for: .normal)
        phoneButton.setTitle("Phone", for: .normal)
        directionsButton.setTitle("Directions", for: .normal)
        
        websiteButton.setTitleColor(.black, for: .normal)
        websiteButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        phoneButton.setTitleColor(.black, for: .normal)
        phoneButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        directionsButton.setTitleColor(.black, for: .normal)
        directionsButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        
        websiteButton.layer.cornerRadius = 5
        websiteButton.clipsToBounds = true
        phoneButton.layer.cornerRadius = 5
        phoneButton.clipsToBounds = true
        directionsButton.layer.cornerRadius = 5
        directionsButton.clipsToBounds = true
        
        let websiteTap = UITapGestureRecognizer(target: self, action: #selector(openInSafari))
        websiteButton.addGestureRecognizer(websiteTap)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(makePhoneCall))
        phoneButton.addGestureRecognizer(phoneTap)
        
        let directionsTap = UITapGestureRecognizer(target: self, action: #selector(giveDirections))
        directionsButton.addGestureRecognizer(directionsTap)
    }

}
