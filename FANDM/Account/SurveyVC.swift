//
//  SurveyVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import Firebase

class SurveyVC: UIViewController {
    
    var userData: UserData?
    
    let dobTextField = UITextField()
    let studentTextField = UITextField()
    let frequencyTextField = UITextField()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.39, green: 0.18, blue: 0.24, alpha: 1.00)
        
        let logoPic = UIImageView()
        view.addSubview(logoPic)
        logoPic.frame = CGRect(x: view.frame.midX - 80, y: 60, width: 160, height: 85)
        logoPic.image = UIImage(named: "Logo")
        logoPic.contentMode = .scaleAspectFit
        
        let promptLabel = UILabel()
        view.addSubview(promptLabel)
        promptLabel.text = "Tell us a little about you..."
        promptLabel.font = UIFont(name: "Poppins-SemiBold", size: 22)
        promptLabel.textColor = .white
        promptLabel.backgroundColor = .clear
        promptLabel.sizeToFit()
        promptLabel.frame = CGRect(x: (view.frame.width - 280) / 2, y: view.frame.midY / 2, width: promptLabel.frame.width, height: promptLabel.frame.height)
        
        
        view.addSubview(dobTextField)
        dobTextField.font = UIFont(name: "Poppins-SemiBold", size: 18)
        dobTextField.frame = CGRect(x: 32, y: promptLabel.frame.maxY + 72, width: view.frame.width - 64, height: 20)
        dobTextField.backgroundColor = .clear
        dobTextField.textColor = .white
        dobTextField.attributedPlaceholder = NSAttributedString(string: "Date of Birth (MM/DD/YYYY)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let dobUnderline = CALayer()
        dobUnderline.frame = CGRect(x: 0, y: dobTextField.frame.height + 4, width: dobTextField.frame.width, height: 1.5)
        dobUnderline.backgroundColor = UIColor.white.cgColor
        dobTextField.layer.addSublayer(dobUnderline)
        
        view.addSubview(studentTextField)
        studentTextField.font = UIFont(name: "Poppins-SemiBold", size: 18)
        studentTextField.frame = CGRect(x: 32, y: dobTextField.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        studentTextField.backgroundColor = .clear
        studentTextField.textColor = .white
        studentTextField.attributedPlaceholder = NSAttributedString(string: "Are you a student at VT?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let studentUnderline = CALayer()
        studentUnderline.frame = CGRect(x: 0, y: studentTextField.frame.height + 4, width: studentTextField.frame.width, height: 1.5)
        studentUnderline.backgroundColor = UIColor.white.cgColor
        studentTextField.layer.addSublayer(studentUnderline)
        
        view.addSubview(frequencyTextField)
        frequencyTextField.font = UIFont(name: "Poppins-SemiBold", size: 18)
        frequencyTextField.frame = CGRect(x: 32, y: studentTextField.frame.maxY + 32, width: view.frame.width - 64, height: 20)
        frequencyTextField.backgroundColor = .clear
        frequencyTextField.textColor = .white
        frequencyTextField.attributedPlaceholder = NSAttributedString(string: "How often do you visit First & Main?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let frequencyUnderline = CALayer()
        frequencyUnderline.frame = CGRect(x: 0, y: frequencyTextField.frame.height + 4, width: studentTextField.frame.width, height: 1.5)
        frequencyUnderline.backgroundColor = UIColor.white.cgColor
        frequencyTextField.layer.addSublayer(frequencyUnderline)
        
        let frequencyBottom = frequencyTextField.frame.maxY
        let sizeOfButtons: CGFloat = 45 + 45 + 8 // size of 2 buttons plus spacing
        let yOffset = (view.frame.maxY + frequencyBottom) / 2 - sizeOfButtons/2 - 20
        
        let skipButtom = UIButton()
        view.addSubview(skipButtom)
        skipButtom.setTitle("Skip", for: .normal)
        skipButtom.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        let skipPressed = UITapGestureRecognizer(target: self, action: #selector(skipTapped))
        skipButtom.addGestureRecognizer(skipPressed)
        
        skipButtom.frame = CGRect(x: (view.frame.width - 280) / 2, y: yOffset, width: 280, height: 45)
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
        if (dobTextField.text == "") {
            let alert = UIAlertController(title: "Please enter your date of birth.", message: "Use the following format: MM/DD/YYYY", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let dobVerified = true
        if (!dobVerified) {
            let alert = UIAlertController(title: "Please enter a valid date of birth.", message: "Use the following format: MM/DD/YYYY", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (studentTextField.text == "") {
            let alert = UIAlertController(title: "Please answer whether or not you are a student at VT.", message: "If you go to another university, enter a that university or say \"No\".", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (frequencyTextField.text == nil) {
            let alert = UIAlertController(title: "Please tell us how often you go to First & Main.", message: "Ex: 0-2 visits per month, etc.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let surveyResults: [String: Any] = ["dob": dobTextField.text!, "student": studentTextField.text!, "frequency": frequencyTextField.text!]
        
        db.collection("SurveyResults").document().setData(surveyResults)
        clearInputs()
        self.performSegue(withIdentifier: "rewindFromSurvey", sender: self)
    }
    
    func clearInputs() {
        dobTextField.text = ""
        studentTextField.text = ""
        frequencyTextField.text = ""
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
