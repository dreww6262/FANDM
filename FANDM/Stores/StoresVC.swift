//
//  ViewController.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase


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
    
    var restaurantList = [Store]()
    var shopsList = [Store]()
    var servicesList = [Store]()
    var entertainmentList = [Store]()
    var favList = [Store]()
    var offerList = [Store]() //  make offer class
    var popularList = [Store]()
    
    var unassignedStores = [Store]()
    
    var db = Firestore.firestore()
    var storage = Storage.storage().reference()
    var userData: UserData?
    var userDataRef: DocumentReference?
    
    let favEmpty = UILabel()
    let offersEmpty = UILabel()
    let popularEmpty = UILabel()
        
    func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height * 1.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filterButtonCollection:
            return 4
        case favCollection:

            if favList.count == 0 {
                favEmpty.isHidden = false
                favCollection.frame = CGRect(x: favCollection.frame.minX, y: favCollection.frame.minY, width: favCollection.frame.width, height: 80)
            }
            else {
                favEmpty.isHidden = true
                favCollection.frame = CGRect(x: favCollection.frame.minX, y: favCollection.frame.minY, width: favCollection.frame.width, height: view.frame.height/4)
            }
            fixLocations()
            return favList.count
        case offerCollection:
            if offerList.count == 0 {
                offersEmpty.isHidden = false
                offerCollection.frame = CGRect(x: offerCollection.frame.minX, y: offerCollection.frame.minY, width: offerCollection.frame.width, height: 80)
            }
            else {
                offersEmpty.isHidden = true
                offerCollection.frame = CGRect(x: offerCollection.frame.minX, y: offerCollection.frame.minY, width: offerCollection.frame.width, height: view.frame.height/4)
            }
            fixLocations()
            return offerList.count
        case popularCollection:
            if popularList.count == 0 {
                popularEmpty.isHidden = false
                popularCollection.frame = CGRect(x: popularCollection.frame.minX, y: popularCollection.frame.minY, width: popularCollection.frame.width, height: 80)
            }
            else {
                popularEmpty.isHidden = true
                popularCollection.frame = CGRect(x: popularCollection.frame.minX, y: popularCollection.frame.minY, width: popularCollection.frame.width, height: view.frame.height/4)
            }
            fixLocations()
            return popularList.count
        case restaurantCollection:
            return restaurantList.count
        case shopsCollection:
            return shopsList.count
        case servicesCollection:
            return servicesList.count
        case entertainmentCollection:
            return entertainmentList.count
        default:
            return 6
        }
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
            
            
            
            var store: Store?
            var type: String?
            switch collectionView {
            case favCollection:
                type = "fav"
                store = favList[indexPath.row]
            case popularCollection:
                type = "popular"
                store = unassignedStores.first(where: {s in
                    return true
                })
            case restaurantCollection:
                type = "restaurant"
                store = restaurantList[indexPath.row]

            case shopsCollection:
                type = "shops"
                store = shopsList[indexPath.row]

            case servicesCollection:
                type = "services"
                store = servicesList[indexPath.row]

            case entertainmentCollection:
                type = "entertainment"
                store = entertainmentList[indexPath.row]

            default:
                print("Error")
                store = Store(name: "error", description: "error", imageLink: "error", type: "error", lat: 0.0, long: 0.0, address: "none", phone: "bad", website: "www.google.com")
            }
            
            cell.store = store
            cell.name.text = store!.name
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
            if (userData != nil && userData!.favoriteStores.contains(store!.name)) {
                cell.favButton.setImage(UIImage(named: "curvedfilled"), for: .normal)
                favList.append(store!)
            }
            else {
                cell.favButton.setImage(UIImage(named: "curvedempty"), for: .normal)
            }
            cell.favButton.imageView?.frame = CGRect(x: 0, y: 0, width: cell.favButton.frame.width, height: cell.favButton.frame.height)
            cell.favButton.imageView?.contentMode = .scaleAspectFit
            let favTapped = UITapGestureRecognizer(target: self, action: #selector(handleFavButton))
            cell.favButton.addGestureRecognizer(favTapped)
            
            let url = URL(string: store!.imageLink)
            
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
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "" || searchBar.text == "") {
            print(searchText)
            searchVC?.view.removeFromSuperview()
            searchVC?.removeFromParent()
            scrollView.isScrollEnabled = true
            return
        }
        else if (searchVC?.parent == nil) {
            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.safeAreaInsets.top), animated: false)
            addChild(searchVC!)
            view.addSubview(searchVC!.view)
            let yOffset = searchBar.frame.maxY + 16
            let height = view.frame.height - yOffset - scrollView.safeAreaInsets.bottom - scrollView.safeAreaInsets.top
            searchVC!.view.frame = CGRect(x: 0, y: yOffset + scrollView.safeAreaInsets.top, width: scrollView.frame.width, height: height)
            //searchVC!.view.frame = contentView.convert(CGRect(x: 0, y: yOffset, width: view.frame.width, height: view.frame.height - yOffset - tabBarController!.tabBar.frame.height - 8), to: view.coordinateSpace)
            scrollView.isScrollEnabled = false
        }
        else {
            scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.safeAreaInsets.top), animated: false)
        }
        print("content offset \(scrollView.contentOffset)")
        print("content insets \(scrollView.safeAreaInsets)")
        
        
        var searchResults = [Store]()
        for store in unassignedStores {
            if (store.name.contains(searchText)) {
                searchResults.append(store)
            }
        }
        searchVC?.storeList = searchResults
    }
    
    var searchVC: SearchResultsVC?
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (searchVC?.parent != nil) {
            return
        }
        searchVC = storyboard?.instantiateViewController(identifier: "searchVC") as? SearchResultsVC
        //let yOffset = searchBar.frame.maxY + 16
        searchVC!.userData = userData
        searchVC!.userDataRef = userDataRef
        searchVC!.searchBar = searchBar
        
//        addChild(searchVC!)
//        view.addSubview(searchVC!.view)
//        searchVC!.view.frame = contentView.convert(CGRect(x: 0, y: yOffset, width: view.frame.width, height: scrollView.frame.height - yOffset), to: view.coordinateSpace)
//        scrollView.isScrollEnabled = false
    }
    
    @objc func offerCellClicked(_ sender: UITapGestureRecognizer) {
        let offerCell = sender.view as! OfferCell
        print("Clicked on offer cell with store \(offerCell.storeNameLabel!.text!)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = view.frame
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        //contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1500)
        
        setUpNavBar()
        setUpSearchBar()
        
        //filterByLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        //filterByLabel.sizeToFit()
        //filterByLabel.frame = CGRect(x: 8, y: searchBar.frame.maxY + 16, width: filterByLabel.frame.width, height: filterByLabel.frame.height)
        
        //setUpFilterButtonCollection()
        setUpFavCollection()
        setUpOfferCollection()
        setUpPopularCollection()
        setUpRestaurantCollection()
        setUpShopsCollection()
        setUpServicesCollection()
        setUpEntertainmentCollection()
        contentView.bringSubviewToFront(shopsLabel)
        contentView.bringSubviewToFront(popLabel)
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: entertainmentCollection.frame.maxY + 16)
        scrollView.contentSize = contentView.bounds.size
        
        setUpEmptyLabels()
        
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: entertainmentCollection.frame.maxY + 16)
        print(contentView.frame.height)
        contentView.isUserInteractionEnabled = true
        scrollView.contentSize = contentView.bounds.size
        
        db.collection("Stores").addSnapshotListener({ object, error in
            guard let documents = object?.documents else {
                return
            }
            self.unassignedStores.removeAll(keepingCapacity: true)
            self.shopsList.removeAll(keepingCapacity: true)
            self.restaurantList.removeAll(keepingCapacity: true)
            self.servicesList.removeAll(keepingCapacity: true)
            self.entertainmentList.removeAll(keepingCapacity: true)
            
            for doc in documents {
                let store = Store(dictionary: doc.data())
                self.unassignedStores.append(store)
                switch store.type {
                case "Shops":
                    self.shopsList.append(store)
                case "Dining & Bevs":
                    self.restaurantList.append(store)
                case "Services":
                    self.servicesList.append(store)
                case "Entertainment":
                    self.entertainmentList.append(store)
                default:
                    print("did not get correct type")
                }
            }
            self.reloadCollections()
            self.unassignedStores.sort(by: { x, y in
                return x.name < y.name
            })
        })
        
    }
    
    func reloadCollections() {
        favList.removeAll(keepingCapacity: true)
        offerCollection.reloadData()
        popularCollection.reloadData()
        shopsCollection.reloadData()
        servicesCollection.reloadData()
        restaurantCollection.reloadData()
        entertainmentCollection.reloadData()
        favCollection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        if (user != nil) {
            if (userData == nil || userData!.email != user?.email) {
                db.collection("UserData").whereField("email", isEqualTo: user!.email!).getDocuments(completion: { obj, error in
                    guard let docs = obj?.documents else {
                        return
                    }
                    if (docs.count > 0) {
                        self.userData = UserData(dictionary: docs[0].data())
                        self.userDataRef = docs[0].reference
                    }
                    self.reloadCollections()
                })
            }
        }
        self.reloadCollections()
        
        
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
    
//    func setUpFilterButtonCollection() {
//        filterButtonCollection.frame = CGRect(x: 8, y: filterByLabel.frame.maxY + 8, width: view.frame.width - 16, height: 36)
//        filterButtonCollection.canCancelContentTouches = true
//        filterButtonCollection.allowsMultipleSelection = false
//        filterButtonCollection.showsHorizontalScrollIndicator = false
//        filterButtonCollection.isUserInteractionEnabled = true
//        print("sections in filter collection \(filterButtonCollection.numberOfSections)")
//    }
    
    func setUpFavCollection() {
        let favLabel = UILabel()
        contentView.addSubview(favLabel)
        favLabel.text = "Your Favorites"
        favLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        favLabel.frame = CGRect(x: 8, y: searchBar.frame.maxY + 16, width: 150, height: 14)
        favLabel.textColor = .black
        favLabel.textAlignment = .left
        
        favCollection.frame = CGRect(x: 8, y: favLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        favCollection.backgroundColor = .black
        
        favCollection.showsHorizontalScrollIndicator = false
        favCollection.canCancelContentTouches = true
        favCollection.isUserInteractionEnabled = true
        favCollection.backgroundColor = .black
        favCollection.clipsToBounds = false
        
        let itemSize = favCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        favCollection.collectionViewLayout = layout
        favCollection.backgroundColor = .white
        
        
    }
    
    let offerLabel = UILabel()
    func setUpOfferCollection() {
        contentView.addSubview(offerLabel)
        offerLabel.text = "Offers"
        offerLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        offerLabel.frame = CGRect(x: 8, y: favCollection.frame.maxY + 20, width: 150, height: 14)
        offerLabel.textColor = .black
        offerLabel.textAlignment = .left
        
        //offerCollection.register(OfferCell.self, forCellWithReuseIdentifier: "offerCell")
        offerCollection.frame = CGRect(x: 8, y: offerLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        //offerCollection.allowsMultipleSelection = false
        offerCollection.showsHorizontalScrollIndicator = false
        offerCollection.canCancelContentTouches = true
        offerCollection.isUserInteractionEnabled = true
        offerCollection.backgroundColor = .black
        offerCollection.clipsToBounds = false
        
        let itemSize = offerCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        offerCollection.collectionViewLayout = layout
        offerCollection.backgroundColor = .white
    }
    
    let popLabel = UILabel()
    func setUpPopularCollection() {
        
        contentView.addSubview(popLabel)
        popLabel.text = "Popular"
        popLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        popLabel.frame = CGRect(x: 8, y: offerCollection.frame.maxY + 20, width: 150, height: 14)
        popLabel.textColor = .black
        popLabel.textAlignment = .left
        
        popularCollection.frame = CGRect(x: 8, y: popLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        popularCollection.backgroundColor = .black
        
        popularCollection.showsHorizontalScrollIndicator = false
        popularCollection.canCancelContentTouches = true
        popularCollection.isUserInteractionEnabled = true
        popularCollection.backgroundColor = .black
        popularCollection.clipsToBounds = false
        
        let itemSize = popularCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        popularCollection.collectionViewLayout = layout
        popularCollection.backgroundColor = .white

    }
    
    let restLabel = UILabel()
    func setUpRestaurantCollection() {
        
        contentView.addSubview(restLabel)
        restLabel.text = "Restaurants"
        restLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        restLabel.frame = CGRect(x: 8, y: popularCollection.frame.maxY + 20, width: 150, height: 14)
        restLabel.textColor = .black
        restLabel.textAlignment = .left
        
        restaurantCollection.frame = CGRect(x: 8, y: restLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        restaurantCollection.backgroundColor = .black
        
        restaurantCollection.showsHorizontalScrollIndicator = false
        restaurantCollection.canCancelContentTouches = true
        restaurantCollection.isUserInteractionEnabled = true
        restaurantCollection.backgroundColor = .black
        restaurantCollection.clipsToBounds = false
        
        let itemSize = restaurantCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        restaurantCollection.collectionViewLayout = layout
        restaurantCollection.backgroundColor = .white

    }
    
    let shopsLabel = UILabel()
    func setUpShopsCollection() {
        
        contentView.addSubview(shopsLabel)
        shopsLabel.text = "Shops"
        shopsLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        shopsLabel.frame = CGRect(x: 8, y: restaurantCollection.frame.maxY + 20, width: 150, height: 14)
        shopsLabel.textColor = .black
        shopsLabel.textAlignment = .left
        
        shopsCollection.frame = CGRect(x: 8, y: shopsLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        shopsCollection.backgroundColor = .black
        
        shopsCollection.showsHorizontalScrollIndicator = false
        shopsCollection.canCancelContentTouches = true
        shopsCollection.isUserInteractionEnabled = true
        shopsCollection.backgroundColor = .black
        shopsCollection.clipsToBounds = false
        
        let itemSize = shopsCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        shopsCollection.collectionViewLayout = layout
        shopsCollection.backgroundColor = .white

    }
    
    let servicesLabel = UILabel()
    func setUpServicesCollection() {
        
        contentView.addSubview(servicesLabel)
        servicesLabel.text = "Services"
        servicesLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        servicesLabel.frame = CGRect(x: 8, y: shopsCollection.frame.maxY + 20, width: 150, height: 14)
        servicesLabel.textColor = .black
        servicesLabel.textAlignment = .left
        
        servicesCollection.frame = CGRect(x: 8, y: servicesLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        servicesCollection.backgroundColor = .black
        
        servicesCollection.showsHorizontalScrollIndicator = false
        servicesCollection.canCancelContentTouches = true
        servicesCollection.isUserInteractionEnabled = true
        servicesCollection.backgroundColor = .black
        servicesCollection.clipsToBounds = false
        
        let itemSize = servicesCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        servicesCollection.collectionViewLayout = layout
        servicesCollection.backgroundColor = .white

    }
    
    let entLabel = UILabel()
    func setUpEntertainmentCollection() {
        
        contentView.addSubview(entLabel)
        entLabel.text = "Entertainment"
        entLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        entLabel.frame = CGRect(x: 8, y: servicesCollection.frame.maxY + 20, width: 150, height: 14)
        entLabel.textColor = .black
        entLabel.textAlignment = .left
        
        entertainmentCollection.frame = CGRect(x: 8, y: entLabel.frame.maxY + 12, width: view.frame.width - 16, height: view.frame.height/4)
        entertainmentCollection.backgroundColor = .black
        
        entertainmentCollection.showsHorizontalScrollIndicator = false
        entertainmentCollection.canCancelContentTouches = true
        entertainmentCollection.isUserInteractionEnabled = true
        entertainmentCollection.backgroundColor = .black
        entertainmentCollection.clipsToBounds = false
        
        let itemSize = entertainmentCollection.frame.height

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize * 1.5, height: itemSize)

        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        entertainmentCollection.collectionViewLayout = layout
        entertainmentCollection.backgroundColor = .white

    }
    
    func setUpEmptyLabels() {
        contentView.addSubview(favEmpty)
        if (Auth.auth().currentUser == nil) {
            favEmpty.text = "Sign in to add favorites!"
        }
        else {
            favEmpty.text = "Add favorites to see them here!"
        }
        favEmpty.font = UIFont(name: "Poppins-SemiBold", size: 18)
        favEmpty.textColor = .white
        favEmpty.frame = CGRect(x: 20, y: favCollection.frame.minY + 20, width: contentView.frame.width - 40, height: 40)
        favEmpty.textAlignment = .center
        favEmpty.backgroundColor = UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00)
        favEmpty.layer.cornerRadius = 10
        favEmpty.clipsToBounds = true
        if (favList.count != 0) {
            favEmpty.isHidden = true
        }
        
        contentView.addSubview(offersEmpty)
        offersEmpty.text = "No offers available right now."
        offersEmpty.font = UIFont(name: "Poppins-SemiBold", size: 18)
        offersEmpty.textColor = .white
        offersEmpty.frame = CGRect(x: 20, y: offerCollection.frame.minY + 20, width: view.frame.width - 40, height: 40)
        offersEmpty.textAlignment = .center
        offersEmpty.backgroundColor = UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00)
        offersEmpty.layer.cornerRadius = 10
        offersEmpty.clipsToBounds = true
        if (offerList.count != 0) {
            offersEmpty.isHidden = true
        }
        
        contentView.addSubview(popularEmpty)
        popularEmpty.text = "No popular available right now."
        popularEmpty.font = UIFont(name: "Poppins-SemiBold", size: 18)
        popularEmpty.textColor = .white
        popularEmpty.frame = CGRect(x: 20, y: popularCollection.frame.minY + 20, width: view.frame.width - 40, height: 40)
        popularEmpty.textAlignment = .center
        popularEmpty.backgroundColor = UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00)
        popularEmpty.layer.cornerRadius = 10
        popularEmpty.clipsToBounds = true
        if (popularList.count != 0) {
            popularEmpty.isHidden = true
        }
    }
    
    func fixLocations() {
        offerLabel.frame = CGRect(x: 8, y: favCollection.frame.maxY + 20, width: offerLabel.frame.width, height: offerLabel.frame.height)
        offerCollection.frame = CGRect(x: 8, y: offerLabel.frame.maxY + 12, width: view.frame.width - 16, height: offerCollection.frame.height)
        offersEmpty.frame = CGRect(x: 20, y: offerCollection.frame.minY + 20, width: view.frame.width - 40, height: 40)
        
        popLabel.frame = CGRect(x: 8, y: offerCollection.frame.maxY + 20, width: 150, height: 14)
        popularCollection.frame = CGRect(x: 8, y: popLabel.frame.maxY + 12, width: view.frame.width - 16, height: popularCollection.frame.height)
        popularEmpty.frame = CGRect(x: 20, y: popularCollection.frame.minY + 20, width: view.frame.width - 40, height: 40)
        
        restLabel.frame = CGRect(x: 8, y: popularCollection.frame.maxY + 20, width: 150, height: 14)
        restaurantCollection.frame = CGRect(x: 8, y: restLabel.frame.maxY + 12, width: view.frame.width - 16, height: restaurantCollection.frame.height)
        
        shopsLabel.frame = CGRect(x: 8, y: restaurantCollection.frame.maxY + 20, width: 150, height: 14)
        shopsCollection.frame = CGRect(x: 8, y: shopsLabel.frame.maxY + 12, width: view.frame.width - 16, height: shopsCollection.frame.height)
        
        servicesLabel.frame = CGRect(x: 8, y: shopsCollection.frame.maxY + 20, width: 150, height: 14)
        servicesCollection.frame = CGRect(x: 8, y: servicesLabel.frame.maxY + 12, width: view.frame.width - 16, height: servicesCollection.frame.height)
        
        entLabel.frame = CGRect(x: 8, y: servicesCollection.frame.maxY + 20, width: 150, height: 14)
        entertainmentCollection.frame = CGRect(x: 8, y: entLabel.frame.maxY + 12, width: view.frame.width - 16, height: entertainmentCollection.frame.height)
        
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: entertainmentCollection.frame.maxY + 16)
        scrollView.contentSize = contentView.bounds.size
        
        contentView.bringSubviewToFront(shopsLabel)
        contentView.bringSubviewToFront(popLabel)
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
        reloadCollections()
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
        searchBar.endEditing(true)
    }
}
