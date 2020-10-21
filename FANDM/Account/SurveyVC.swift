//
//  SurveyVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit

class SurveyVC: UIViewController {
    
    var userData: UserData?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        
        let promptLabel = UILabel()
        view.addSubview(promptLabel)
        promptLabel.text = "Tell us a little about you..."
        promptLabel.font = UIFont(name: "Poppins-SemiBold", size: 22)
        promptLabel.textColor = .white
        promptLabel.backgroundColor = .clear
        promptLabel.sizeToFit()
        promptLabel.frame = CGRect(x: (view.frame.width - 280) / 2, y: view.frame.midY - 200, width: promptLabel.frame.width, height: promptLabel.frame.height)
        
        let skipButtom = UIButton()
        view.addSubview(skipButtom)
        skipButtom.setTitle("Skip", for: .normal)
        skipButtom.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        let skipPressed = UITapGestureRecognizer(target: self, action: #selector(skipTapped))
        skipButtom.addGestureRecognizer(skipPressed)
        
        skipButtom.frame = CGRect(x: (view.frame.width - 280) / 2, y: view.frame.midY + 50, width: 280, height: 45)
        skipButtom.layer.cornerRadius = 22
        skipButtom.clipsToBounds = true
        skipButtom.backgroundColor = .clear
        skipButtom.layer.borderColor = UIColor.white.cgColor
        skipButtom.layer.borderWidth = 2
        
        let finishButton = UIButton()
        view.addSubview(finishButton)
        finishButton.setTitle("Finish", for: .normal)
        finishButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        finishButton.setTitleColor(UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00), for: .normal)
        finishButton.backgroundColor = .white
        let finishPressed = UITapGestureRecognizer(target: self, action: #selector(finishTapped))
        finishButton.addGestureRecognizer(finishPressed)
        
        finishButton.frame = CGRect(x: (view.frame.width - 280) / 2, y: skipButtom.frame.maxY + 8, width: 280, height: 45)
        finishButton.layer.cornerRadius = 22
        finishButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @objc func skipTapped(_ sender: UITapGestureRecognizer) {
        clearInputs()
        self.performSegue(withIdentifier: "rewindFromSurvey", sender: self)
    }
    
    @objc func finishTapped(_ sender: UITapGestureRecognizer) {
        clearInputs()
        self.performSegue(withIdentifier: "rewindFromSurvey", sender: self)
    }
    
    func clearInputs() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AccountVC {
            let dest = segue.destination as! AccountVC
            dest.userData = userData
        }
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
