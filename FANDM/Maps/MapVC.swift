//
//  MapVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

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
        
        filterByLabel.font = UIFont(name: "Poppins-SemiBold", size: 12)
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
        let fakeMap = UIImageView()
        contentView.addSubview(fakeMap)
        let yPos = filterButtonCollection.frame.maxY + 16
        fakeMap.frame = CGRect(x: 0, y: yPos, width: contentView.frame.width, height: contentView.frame.height - yPos)
        fakeMap.image = UIImage(named: "fake_map")
        fakeMap.contentMode = .scaleAspectFill
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
