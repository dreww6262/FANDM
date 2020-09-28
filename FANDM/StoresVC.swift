//
//  ViewController.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import SDWebImage

class StoresVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterByLabel: UILabel!
    
    @IBOutlet weak var filterButtonCollection: UICollectionView!
    
    @IBOutlet weak var favCollection: UICollectionView!
    
    @IBOutlet weak var offerCollection: UICollectionView!
    
    @IBOutlet weak var popularCollection: UICollectionView!
    
    @IBOutlet weak var restaurantCollection: UICollectionView!
    
    @IBOutlet weak var shopsCollection: UICollectionView!
    
    @IBOutlet weak var servicesCollection: UICollectionView!
    
    @IBOutlet weak var entertainmentCollection: UICollectionView!
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterButtonCollection {
            return 4
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case filterButtonCollection:
            let cell = filterButtonCollection.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
            let buttonNames = ["Restaurants", "Shops", "Services", "Entertainment"]
            cell.buttonName = buttonNames[indexPath.row]
            cell.filterButton.layer.cornerRadius = 10
            cell.filterButton.clipsToBounds = true
            return cell
            
            
        case offerCollection:
            let cell = offerCollection.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! OfferCell
            cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 120, height: offerCollection.frame.height)
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.clipsToBounds = true
            cell.layer.masksToBounds = false
            cell.backgroundColor = .clear
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 8
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
            
            let offerTap = UITapGestureRecognizer(target: self, action: #selector(offerCellClicked))
            cell.addGestureRecognizer(offerTap)
            
            // set up image
            cell.storeImage?.image = UIImage(named: "firstandmaindefault")
            cell.storeImage?.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            cell.storeImage?.contentMode = .scaleAspectFill
            
            let label = UILabel()
            cell.addSubview(label)
            // set up label
            label.text = "Offer"
            label.font = UIFont(name: "Poppins-SemiBold", size: 12)
            label.frame = CGRect(x: 5, y: cell.frame.height - 17, width: 70, height: 12)
            label.textAlignment = .left
            cell.bringSubviewToFront(label)
            cell.sendSubviewToBack(cell.storeImage!)
            
            label.textColor = .black
            
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultStoreCell", for: indexPath) as! DefaultStoreCell
            cell.frame = CGRect(x: cell.frame.minX, y: cell.frame.minY, width: 120, height: collectionView.frame.height)
            
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.clipsToBounds = true
            //cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = false
            cell.backgroundColor = .clear
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 8
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
            
            let offerTap = UITapGestureRecognizer(target: self, action: #selector(offerCellClicked))
            cell.addGestureRecognizer(offerTap)
            
            let favButton = UIButton()
            cell.contentView.addSubview(favButton)
            favButton.frame = CGRect(x: cell.frame.width - 25, y: cell.frame.height - 25, width: 20, height: 20)
            favButton.backgroundColor = .clear
            favButton.tintColor = .clear
            favButton.setTitle("", for: .normal)
            favButton.setImage(UIImage(named: "curvedempty"), for: .normal)
            favButton.imageView?.frame = CGRect(x: 0, y: 0, width: favButton.frame.width, height: favButton.frame.height)
            favButton.imageView?.contentMode = .scaleAspectFit
            
            let storeNameLabel = UILabel()
            cell.contentView.addSubview(storeNameLabel)
            storeNameLabel.text = "Default"
            storeNameLabel.font = UIFont(name: "Poppins-SemiBold", size: 12)
            storeNameLabel.frame = CGRect(x: 5, y: cell.frame.height - 17, width: 70, height: 12)
            storeNameLabel.textAlignment = .left
            storeNameLabel.textColor = .black
            
            // set up image
            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.image = UIImage(named: "firstandmaindefault")
            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            imageView.contentMode = .scaleAspectFill
            
            cell.contentView.sendSubviewToBack(imageView)
            
            return cell
        }
    }
    
    @objc func offerCellClicked(_ sender: UITapGestureRecognizer) {
        let offerCell = sender.view as! OfferCell
        print("Clicked on offer cell with store \(offerCell.storeNameLabel!.text!)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = view.frame
        scrollView.isUserInteractionEnabled = true
        //contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1500)
        
        setUpNavBar()
        setUpSearchBar()
        
        filterByLabel.font = UIFont(name: "Poppins-SemiBold", size: 12)
        filterByLabel.frame = CGRect(x: 8, y: searchBar.frame.maxY + 16, width: filterByLabel.frame.width, height: filterByLabel.frame.height)
        
        setUpFilterButtonCollection()
        setUpFavCollection()
        setUpOfferCollection()
        setUpPopularCollection()
        setUpRestaurantCollection()
        setUpShopsCollection()
        setUpServicesCollection()
        setUpEntertainmentCollection()
        
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: entertainmentCollection.frame.maxY + 16)
        print(contentView.frame.height)
        contentView.isUserInteractionEnabled = true
        scrollView.contentSize = contentView.frame.size
    }
    
    func setUpNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.white
        navBar?.isTranslucent = true
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.shadowImage = UIImage()
    }
    
    func setUpSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 8, width: view.frame.width - 16, height: 36)
        searchBar.backgroundImage = UIImage()
    }
    
    func setUpFilterButtonCollection() {
        filterButtonCollection.frame = CGRect(x: 8, y: filterByLabel.frame.maxY + 8, width: view.frame.width - 16, height: 36)
        filterButtonCollection.canCancelContentTouches = true
        filterButtonCollection.allowsMultipleSelection = false
        filterButtonCollection.showsHorizontalScrollIndicator = false
        filterButtonCollection.isUserInteractionEnabled = true
        print("sections in filter collection \(filterButtonCollection.numberOfSections)")
    }
    
    func setUpFavCollection() {
        let favLabel = UILabel()
        contentView.addSubview(favLabel)
        favLabel.text = "Your Favorites"
        favLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        favLabel.frame = CGRect(x: 8, y: filterButtonCollection.frame.maxY + 16, width: 150, height: 14)
        favLabel.textColor = .black
        favLabel.textAlignment = .left
        
        favCollection.frame = CGRect(x: 8, y: favLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        favCollection.backgroundColor = .black
        
        favCollection.showsHorizontalScrollIndicator = false
        favCollection.canCancelContentTouches = true
        favCollection.isUserInteractionEnabled = true
        favCollection.backgroundColor = .black
        favCollection.clipsToBounds = false
        
        let itemSize = favCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        favCollection.collectionViewLayout = layout
        favCollection.backgroundColor = .white
    }
    
    
    func setUpOfferCollection() {
        let offerLabel = UILabel()
        contentView.addSubview(offerLabel)
        offerLabel.text = "Offers"
        offerLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        offerLabel.frame = CGRect(x: 8, y: favCollection.frame.maxY + 16, width: 150, height: 14)
        offerLabel.textColor = .black
        offerLabel.textAlignment = .left
        
        //offerCollection.register(OfferCell.self, forCellWithReuseIdentifier: "offerCell")
        offerCollection.frame = CGRect(x: 8, y: offerLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        //offerCollection.allowsMultipleSelection = false
        offerCollection.showsHorizontalScrollIndicator = false
        offerCollection.canCancelContentTouches = true
        offerCollection.isUserInteractionEnabled = true
        offerCollection.backgroundColor = .black
        offerCollection.clipsToBounds = false
        
        let itemSize = offerCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        offerCollection.collectionViewLayout = layout
        offerCollection.backgroundColor = .white

    }
    
    func setUpPopularCollection() {
        let popLabel = UILabel()
        contentView.addSubview(popLabel)
        popLabel.text = "Popular"
        popLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        popLabel.frame = CGRect(x: 8, y: offerCollection.frame.maxY + 16, width: 150, height: 14)
        popLabel.textColor = .black
        popLabel.textAlignment = .left
        
        popularCollection.frame = CGRect(x: 8, y: popLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        popularCollection.backgroundColor = .black
        
        popularCollection.showsHorizontalScrollIndicator = false
        popularCollection.canCancelContentTouches = true
        popularCollection.isUserInteractionEnabled = true
        popularCollection.backgroundColor = .black
        popularCollection.clipsToBounds = false
        
        let itemSize = popularCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        popularCollection.collectionViewLayout = layout
        popularCollection.backgroundColor = .white

    }
    
    func setUpRestaurantCollection() {
        let restLabel = UILabel()
        contentView.addSubview(restLabel)
        restLabel.text = "Restaurants"
        restLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        restLabel.frame = CGRect(x: 8, y: popularCollection.frame.maxY + 16, width: 150, height: 14)
        restLabel.textColor = .black
        restLabel.textAlignment = .left
        
        restaurantCollection.frame = CGRect(x: 8, y: restLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        restaurantCollection.backgroundColor = .black
        
        restaurantCollection.showsHorizontalScrollIndicator = false
        restaurantCollection.canCancelContentTouches = true
        restaurantCollection.isUserInteractionEnabled = true
        restaurantCollection.backgroundColor = .black
        restaurantCollection.clipsToBounds = false
        
        let itemSize = restaurantCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        restaurantCollection.collectionViewLayout = layout
        restaurantCollection.backgroundColor = .white

    }
    
    func setUpShopsCollection() {
        let shopsLabel = UILabel()
        contentView.addSubview(shopsLabel)
        shopsLabel.text = "Shops"
        shopsLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        shopsLabel.frame = CGRect(x: 8, y: restaurantCollection.frame.maxY + 16, width: 150, height: 14)
        shopsLabel.textColor = .black
        shopsLabel.textAlignment = .left
        
        shopsCollection.frame = CGRect(x: 8, y: shopsLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        shopsCollection.backgroundColor = .black
        
        shopsCollection.showsHorizontalScrollIndicator = false
        shopsCollection.canCancelContentTouches = true
        shopsCollection.isUserInteractionEnabled = true
        shopsCollection.backgroundColor = .black
        shopsCollection.clipsToBounds = false
        
        let itemSize = shopsCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        shopsCollection.collectionViewLayout = layout
        shopsCollection.backgroundColor = .white

    }
    
    func setUpServicesCollection() {
        let offerLabel = UILabel()
        contentView.addSubview(offerLabel)
        offerLabel.text = "Services"
        offerLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        offerLabel.frame = CGRect(x: 8, y: shopsCollection.frame.maxY + 16, width: 150, height: 14)
        offerLabel.textColor = .black
        offerLabel.textAlignment = .left
        
        servicesCollection.frame = CGRect(x: 8, y: offerLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        servicesCollection.backgroundColor = .black
        
        servicesCollection.showsHorizontalScrollIndicator = false
        servicesCollection.canCancelContentTouches = true
        servicesCollection.isUserInteractionEnabled = true
        servicesCollection.backgroundColor = .black
        servicesCollection.clipsToBounds = false
        
        let itemSize = servicesCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        servicesCollection.collectionViewLayout = layout
        servicesCollection.backgroundColor = .white

    }
    
    func setUpEntertainmentCollection() {
        let entLabel = UILabel()
        contentView.addSubview(entLabel)
        entLabel.text = "Entertainment"
        entLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        entLabel.frame = CGRect(x: 8, y: servicesCollection.frame.maxY + 16, width: 150, height: 14)
        entLabel.textColor = .black
        entLabel.textAlignment = .left
        
        entertainmentCollection.frame = CGRect(x: 8, y: entLabel.frame.maxY + 8, width: view.frame.width - 16, height: 120)
        entertainmentCollection.backgroundColor = .black
        
        entertainmentCollection.showsHorizontalScrollIndicator = false
        entertainmentCollection.canCancelContentTouches = true
        entertainmentCollection.isUserInteractionEnabled = true
        entertainmentCollection.backgroundColor = .black
        entertainmentCollection.clipsToBounds = false
        
        let itemSize = entertainmentCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        entertainmentCollection.collectionViewLayout = layout
        entertainmentCollection.backgroundColor = .white

    }
    
    


}

