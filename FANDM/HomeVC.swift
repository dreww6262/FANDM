//
//  HomeVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let button = UIButton()
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let promoImage = UIImageView()
        let cell = featuredCollection.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath)
        
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
        
        cell.contentView.addSubview(button)
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(descriptionLabel)
        cell.contentView.addSubview(promoImage)
        
        promoImage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height * 0.55)
        promoImage.image = UIImage(named: "firstandmaindefault")
        promoImage.contentMode = .scaleAspectFill
        
        titleLabel.frame = CGRect(x: 8, y: promoImage.frame.maxY + 16, width: cell.frame.width - 16, height: 16)
        titleLabel.textAlignment = .left
        titleLabel.text = "Title Label"
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.contentView.bringSubviewToFront(titleLabel)
        
        descriptionLabel.frame = CGRect(x: 8, y: promoImage.frame.maxY + 36, width: cell.frame.width - 16, height: 14)
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Text description.  (Can be multiple lines)fjhd kslahfjdklahfjdks ghjdsl kjdskafhjd sakhfd aksjhf"
        descriptionLabel.numberOfLines = 3
        descriptionLabel.sizeToFit()
        descriptionLabel.font = UIFont(name: "Poppins-SemiBold", size: 12)
        descriptionLabel.clipsToBounds = false
        cell.contentView.bringSubviewToFront(descriptionLabel)
        
        button.setTitle("See More", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 12)
        button.frame = CGRect(x: 8, y: descriptionLabel.frame.maxY + 8, width: button.titleLabel!.frame.width + 8, height: 24)
        button.backgroundColor = UIColor(red: 0.76, green: 0.32, blue: 0.20, alpha: 1.00)
        button.tintColor = .clear
        button.layer.cornerRadius = 8
        button.sizeToFit()
        button.frame = CGRect(x: 8, y: descriptionLabel.frame.maxY + 8, width: button.frame.width + 8, height: 24)
        button.clipsToBounds = true
        
        
        return cell
    }
    

    @IBOutlet weak var featuredCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpFeaturedCollection()
        
    }
    
    func setUpNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.white
        navBar?.isTranslucent = true
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "Poppins-SemiBold", size: 32) as Any]
        navBar?.shadowImage = UIImage()
    }
    
    func setUpFeaturedCollection() {
        featuredCollection.frame = CGRect(x: 8, y: 16, width: view.frame.width - 16, height: view.frame.height - 16)
        featuredCollection.allowsMultipleSelection = false
        featuredCollection.delegate = self
        featuredCollection.dataSource = self
        
        featuredCollection.showsHorizontalScrollIndicator = false
        featuredCollection.canCancelContentTouches = true
        featuredCollection.isUserInteractionEnabled = true
        featuredCollection.backgroundColor = .black
        featuredCollection.clipsToBounds = false
        //featuredCollection.
        
        let itemSize = featuredCollection.frame.width * 5 / 6

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical

        featuredCollection.collectionViewLayout = layout
        featuredCollection.backgroundColor = .white
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
