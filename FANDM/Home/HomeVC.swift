//
//  HomeVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = featuredCollection.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath) as! FeaturedCell
        
        cell.contentView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        cell.clipsToBounds = true
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.clipsToBounds = true
        cell.layer.masksToBounds = false
        cell.backgroundColor = .clear
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.contentView.backgroundColor = .white
        cell.homeItem = homeItemList[indexPath.row]
        
        
        cell.promoImage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height * 0.55)
        let url = URL(string: homeItemList[indexPath.row].imageString)
        if (url != nil) {
            cell.promoImage.sd_setImage(with: url!, completed: { _,err,_,_  in
                if (err != nil) {
                    cell.promoImage.image = UIImage(named: "firstandmaindefault")
                }
            })
        }
        else {
            cell.promoImage.image = UIImage(named: "firstandmaindefault")
        }
        cell.promoImage.contentMode = .scaleAspectFill
        
        cell.titleLabel.frame = CGRect(x: 16, y: cell.promoImage.frame.maxY + 16, width: cell.frame.width - 32, height: 16)
        cell.titleLabel.textAlignment = .left
        cell.titleLabel.text = homeItemList[indexPath.row].name
        cell.titleLabel.numberOfLines = 1
        cell.titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.contentView.bringSubviewToFront(cell.titleLabel)
        
        cell.descriptionLabel.frame = CGRect(x: 16, y: cell.promoImage.frame.maxY + 36, width: cell.frame.width - 32, height: 14)
        cell.descriptionLabel.textAlignment = .left
        cell.descriptionLabel.text = homeItemList[indexPath.row].description
        cell.descriptionLabel.numberOfLines = 3
        cell.descriptionLabel.sizeToFit()
        cell.descriptionLabel.font = UIFont(name: "Poppins", size: 12)
        cell.descriptionLabel.clipsToBounds = false
        cell.contentView.bringSubviewToFront(cell.descriptionLabel)
        
        cell.button.setTitle("See More", for: .normal)
        cell.button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 14)
        //button.frame = CGRect(x: 16, y: descriptionLabel.frame.maxY + 8, width: button.titleLabel!.frame.width + 8, height: 24)
        cell.button.backgroundColor = UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.00)
        cell.button.tintColor = .clear
        cell.button.layer.cornerRadius = 8
        cell.button.sizeToFit()
        cell.button.frame = CGRect(x: cell.frame.width - cell.button.frame.width - 32, y: cell.descriptionLabel.frame.maxY + 8, width: cell.button.frame.width + 16, height: 32)
        cell.button.clipsToBounds = true
        
        let moreTap = UITapGestureRecognizer(target: self, action: #selector(openDetails))
        cell.button.addGestureRecognizer(moreTap)
        
        
        return cell
    }
    

    @IBOutlet weak var featuredCollection: UICollectionView!
    var homeItemList = [HomeItem]()
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpFeaturedCollection()
        pullHomeitems()
    }

    
    func setUpNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.white
        navBar?.isTranslucent = true
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.shadowImage = UIImage()
    }
    
    func setUpFeaturedCollection() {
        featuredCollection.frame = CGRect(x: (view.frame.width - 350) / 2, y: 16, width: 350, height: view.frame.height - 16)
        featuredCollection.allowsMultipleSelection = false
        featuredCollection.delegate = self
        featuredCollection.dataSource = self
        
        featuredCollection.showsHorizontalScrollIndicator = false
        featuredCollection.canCancelContentTouches = true
        featuredCollection.isUserInteractionEnabled = true
        featuredCollection.backgroundColor = .black
        featuredCollection.clipsToBounds = false
        //featuredCollection.
        
        let itemSize = 350

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical

        featuredCollection.collectionViewLayout = layout
        featuredCollection.backgroundColor = .white
    }
    
    func pullHomeitems() {
        db.collection("Home").getDocuments(completion: { obj, error in
            guard let docs = obj?.documents else {
                return
            }
            
            for doc in docs {
                self.homeItemList.append(HomeItem(dictionary: doc.data()))
            }
            self.featuredCollection.reloadData()
        })
    }
    
    @objc func openDetails(_ sender: UITapGestureRecognizer) {
        let detailsVC = NewsItemDetailsVC()
        let cell = sender.view?.superview?.superview as! FeaturedCell
        detailsVC.modalPresentationStyle = .fullScreen
        detailsVC.homeItem = cell.homeItem
        self.present(detailsVC, animated: false)
    }
    

}
