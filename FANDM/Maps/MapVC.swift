//
//  MapVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class MapVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterButtonCollection.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        let buttonNames = ["Restaurants", "Shops", "Services", "Entertainment"]
        cell.buttonName = buttonNames[indexPath.row]
        cell.filterButton.layer.cornerRadius = 10
        cell.filterButton.clipsToBounds = true
        return cell
    }
    
    
    @IBOutlet weak var filterButtonCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterByLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    let db = Firestore.firestore()
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.white
        navBar?.isTranslucent = true
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.shadowImage = UIImage()
        
        searchBar.frame = CGRect(x: 0, y: 8, width: contentView.frame.width, height: 36)
        contentView.bringSubviewToFront(searchBar)
        searchBar.delegate = self
        
        setUpFilterButtonCollection()
        
        setUpMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func setUpFilterButtonCollection() {
        
        filterByLabel.font = UIFont(name: "Poppins-SemiBold", size: 16)
        filterByLabel.sizeToFit()
        filterByLabel.frame = CGRect(x: 8, y: searchBar.frame.maxY + 16, width: filterByLabel.frame.width, height: filterByLabel.frame.height)
        
        filterButtonCollection.dataSource = self
        filterButtonCollection.delegate = self
        filterButtonCollection.frame = CGRect(x: 8, y: filterByLabel.frame.maxY + 8, width: contentView.frame.width - 16, height: 36)
        filterButtonCollection.canCancelContentTouches = true
        filterButtonCollection.allowsMultipleSelection = false
        filterButtonCollection.showsHorizontalScrollIndicator = false
        filterButtonCollection.isUserInteractionEnabled = true
        print("sections in filter collection \(filterButtonCollection.numberOfSections)")
        
    }
    
    func setUpMap() {
        let yPos = filterButtonCollection.frame.maxY + 16
        print("map ypos: \(yPos)")
        let camera = GMSCameraPosition.camera(withLatitude: 37.213177, longitude: -80.401291, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: yPos, width: contentView.frame.width, height: contentView.frame.height - yPos), camera: camera)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView!.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.contentView.addSubview(mapView!)
        print("map searchbar frame: \(searchBar.frame)")
        print("map collectionview frame: \(filterButtonCollection.frame)")
        print("map frame: \(mapView!.frame)")
        
        
        createMarkers()
    }
    
    
    func createMarkers() {
        // blue orange maroon yellow
        let colors: [UIColor] = [UIColor(red: 0.25, green: 0.46, blue: 0.53, alpha: 1.00), UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.00), UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00), UIColor(red: 0.93, green: 0.75, blue: 0.27, alpha: 1.00)]
        
        
        db.collection("Stores").getDocuments(completion: { obj, error in
            guard let docs = obj?.documents else {
                let alert = UIAlertController(title: "Oops", message: "Unable to add markers.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                return
            }
            for doc in docs {
                let store = Store(dictionary: doc.data())
                let marker = GMSMarker()
                marker.title = store.name
                marker.snippet = store.type
                marker.map = self.mapView!
                marker.position = CLLocationCoordinate2D(latitude: store.lat, longitude: store.long)
                switch (store.type) {
                case "Dining & Bevs":
                    marker.icon = GMSMarker.markerImage(with: colors[0])
                case "Entertainment":
                    marker.icon = GMSMarker.markerImage(with: colors[3])
                case "Services":
                    marker.icon = GMSMarker.markerImage(with: colors[1])
                case "Shops":
                    marker.icon = GMSMarker.markerImage(with: colors[2])
                default:
                    print("shouldnt happen")
                }
            }
        })
    }
    
}
