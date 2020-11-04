//
//  SearchResultsVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/2/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class SearchResultsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultStoreCell", for: indexPath) as! DefaultStoreCell
        cell.contentView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.clipsToBounds = true
        cell.backgroundView?.clipsToBounds = true
        cell.clipsToBounds = true
        //cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = false
        cell.backgroundColor = .clear
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        
//            let offerTap = UITapGestureRecognizer(target: self, action: #selector(offerCellClicked))
//            cell.addGestureRecognizer(offerTap)
        
        
        cell.store = storeList![indexPath.row]
        cell.name.text = cell.store!.name
        cell.name.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.name.sizeToFit()
        cell.name.frame = CGRect(x: 10, y: cell.frame.height - 25, width: cell.name.frame.width, height: cell.name.frame.height)
        cell.name.textAlignment = .left
        cell.name.textColor = .black
        cell.contentView.backgroundColor = .white
        
        cell.favButton.frame = CGRect(x: cell.frame.width - 25, y: cell.frame.height - 25, width: 20, height: 20)
        cell.favButton.backgroundColor = .clear
        cell.favButton.tintColor = .clear
        cell.favButton.setTitle("", for: .normal)
        if (userData != nil && userData!.favoriteStores.contains(cell.store!.name)) {
            cell.favButton.setImage(UIImage(named: "curvedfilled"), for: .normal)
        }
        else {
            cell.favButton.setImage(UIImage(named: "curvedempty"), for: .normal)
        }
        cell.favButton.imageView?.frame = CGRect(x: 0, y: 0, width: cell.favButton.frame.width, height: cell.favButton.frame.height)
        cell.favButton.imageView?.contentMode = .scaleAspectFit
        let favTapped = UITapGestureRecognizer(target: self, action: #selector(handleFavButton))
        cell.favButton.addGestureRecognizer(favTapped)
        
        let url = URL(string: cell.store!.imageLink)
        
        // set up image
        cell.image.sd_setImage(with: url, completed: { a, error, c, d in
            if error != nil {
                cell.image.image = UIImage(named: "firstandmaindefault")
            }
            cell.contentView.bringSubviewToFront(cell.name)
        })
        
        cell.image.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.favButton.frame.minY - 5)
        cell.image.contentMode = .scaleAspectFit
        cell.image.clipsToBounds = true
        
        
        cell.contentView.sendSubviewToBack(cell.image)
        cell.contentView.bringSubviewToFront(cell.name)
        
        let cellTap = UITapGestureRecognizer(target: self, action: #selector(defaultTap))
        cell.addGestureRecognizer(cellTap)
        
        return cell
    }
    
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    var storeList: [Store]? {
        didSet {
            searchResultsCollectionView.reloadData()
        }
    }
    
    var userData: UserData?
    var userDataRef: DocumentReference?
    
    var searchBar: UISearchBar?
    
    
    override func viewDidLoad() {
        setUpCollectionView()
        view = searchResultsCollectionView
    }
    
    func setUpCollectionView() {
        searchResultsCollectionView.contentInsetAdjustmentBehavior = .never
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 350, height: 350/1.5)
        //var inset: CGFloat = (-3.0/4.0 * (350.0 - (350.0/1.5)))
        //inset += 15
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        searchResultsCollectionView.collectionViewLayout = layout
        searchResultsCollectionView.showsVerticalScrollIndicator = false
        searchResultsCollectionView.reloadData()
    }
    
    @objc func handleFavButton(_ sender: UITapGestureRecognizer) {
        let cell = sender.view?.superview?.superview as! DefaultStoreCell
        let store = cell.name.text!
        
        if (userData == nil) {
            let alert = UIAlertController(title: "Not Signed In", message: "Sign in to mark your favorite stores!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if (userData!.favoriteStores.contains(store)) {
            userData?.favoriteStores.removeAll(where: { string in
                return string == store
            })
        }
        else {
            userData?.favoriteStores.append(store)
        }
        userDataRef?.setData(userData!.dictionary)
    }
    
    @objc func defaultTap (_ sender: UITapGestureRecognizer) {
        let details = StoreItemDetailsVC()
        let cell = sender.view as! DefaultStoreCell
        details.store = cell.store
        details.userData = userData
        details.userDataRef = userDataRef
        details.modalPresentationStyle = .fullScreen
        
        self.present(details, animated: false)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar?.endEditing(true)
    }
    
}
