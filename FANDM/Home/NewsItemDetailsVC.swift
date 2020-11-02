//
//  NewsItemDetailsVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/14/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import SDWebImage

class NewsItemDetailsVC: UIViewController {
    
    let navBar = UIView()
    let backButton = UIButton()
    let bannerImage = UIImageView()
    let titleText = UILabel()
    let descriptionText = UILabel()
    let moreInfoButton = UIButton()
    var homeItem: HomeItem?
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.backgroundColor = .white
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        navBar.addSubview(backButton)
        backButton.frame = CGRect(x: 10, y: navBar.frame.midY, width: 75, height: 20)
        backButton.titleLabel?.textAlignment = .left
        backButton.setTitle(" Home", for: .normal)
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
        contentView.addSubview(descriptionText)
        contentView.addSubview(moreInfoButton)
        
        
        
        bannerImage.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: view.frame.height/3)
        
        let url = URL(string: homeItem!.imageString)
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
        bannerImage.contentMode = .scaleAspectFill
        
        titleText.text = homeItem!.name
        titleText.font = UIFont(name: "Poppins-SemiBold", size: 18)
        titleText.sizeToFit()
        titleText.frame = CGRect(x: 20, y: bannerImage.frame.maxY + 16, width: titleText.frame.width, height: titleText.frame.height)
        
        descriptionText.frame = CGRect(x: 20, y: titleText.frame.maxY + 8, width: view.frame.width - 40, height: 1000)
        descriptionText.text = homeItem!.description
        descriptionText.font = UIFont(name: "Poppins", size: 14)
        descriptionText.numberOfLines = 0
        descriptionText.sizeToFit()
        
        let moreInfoUrl = URL(string: homeItem!.moreInfoLink)
        
        if (moreInfoUrl != nil) {
        // 77 = button height + 2 * padding (padding = 16)
            if (descriptionText.frame.maxY > contentView.frame.height - 77) {
                contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: descriptionText.frame.maxY + 77)
                scrollView.contentSize = contentView.bounds.size
            }
            
            // 61 = button height + padding from bottom
            moreInfoButton.frame = CGRect(x: 20, y: contentView.frame.maxY - 61, width: view.frame.width - 40, height: 45)
            moreInfoButton.setTitle("See More On Their Website!", for: .normal)
            moreInfoButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
            moreInfoButton.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
            moreInfoButton.setTitleColor(.white, for: .normal)
            moreInfoButton.tintColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
            moreInfoButton.layer.cornerRadius = 22
            moreInfoButton.clipsToBounds = true
            let moreInfoTap = UITapGestureRecognizer(target: self, action: #selector(openInSafari))
            moreInfoButton.addGestureRecognizer(moreInfoTap)
            
        }
        else {
            if (descriptionText.frame.maxY > contentView.frame.height - 16) {
                contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: descriptionText.frame.maxY + 16)
                scrollView.contentSize = contentView.bounds.size
            }
        }
        
        


        // Do any additional setup after loading the view.
    }
    
    @objc func backPressed(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func openInSafari(_ sender: UITapGestureRecognizer) {
        let url = URL(string: homeItem!.moreInfoLink)
        if (url != nil) {
            UIApplication.shared.open(url!)
        }
        else {
            let alert = UIAlertController(title: "Unable to open link", message: "Try again or come back later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: false)
        }
        
    }

}
