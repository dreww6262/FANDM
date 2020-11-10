//
//  RecordVisitVC.swift
//  FANDM
//
//  Created by Andrew Williamson on 11/9/20.
//  Copyright © 2020 Andrew Williamson. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import Firebase

class RecordVisitVC: UIViewController, QRCodeReaderViewControllerDelegate {
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if (result == nil) {
                return
            }
            print(result!)
            
            if self.storeNames.contains(result!.value) {
                self.db.collection("StoreVisits").document().setData(["username": self.punchCard!.username, "punchCardID": self.punchCard!.docID, "store": result!.value, "date": Date()])
                self.punchCard?.index += 1
                self.db.collection("PunchCard").document(self.punchCard!.docID).setData(self.punchCard!.dictionary)
            }
            
            else {
                let alert = UIAlertController(title: "Not a valid QR code", message: "If you believe this is in error please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        addChild(readerVC)
        view.addSubview(readerVC.view)
        readerVC.view.frame = view.bounds
        // Presents the readerVC as modal form sheet
//        readerVC.modalPresentationStyle = .fullScreen
//
//        show(readerVC, sender: self)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        //dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = newCaptureDevice.device.localizedName
        print("Switching capture to: \(cameraName)")
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    var storeNames = [String]()
    let db = Firestore.firestore()
    var punchCard: PunchCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        db.collection("Stores").getDocuments(completion: {obj, error in
            guard let docs = obj?.documents else {
                return
            }
            for doc in docs {
                self.storeNames.append(doc.get("name") as! String)
            }
        })
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { access in
            if access {
                DispatchQueue.main.sync {
                    self.scanAction(self)
                }
            }
            else {
                self.navigationController?.popViewController(animated: false)
            }
        })
    }
}
