//
//  AddImageViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/4/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import Fusuma

class AddImageViewController: UIViewController, FusumaDelegate, UITextFieldDelegate {

    var item: Item?
    var mode: String = "EditingNew"
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var image: UIImageView!

    @IBAction func SaveButtonPressed(_ sender: Any) {
        if self.priceTextField.text == "" || self.titleTextField.text == "" || self.descriptionTextField.text == "" || image.image == nil {
            return
        } else {
            self.LoaderView.isHidden = false
            self.resignFirstResponder()
            self.view.endEditing(true)
            
            if self.mode == "EditingExisting" {
                imageUploadRequest(image: image.image!, url: "https://quickshareios.herokuapp.com/item/update", param: ["title": self.titleTextField.text!, "description": self.descriptionTextField.text!, "price": self.priceTextField.text!, "user_uid": (GlobalState.user?.id)!, "item_id": (item?.item_id)!])
            } else {
                imageUploadRequest(image: image.image!, url: "https://quickshareios.herokuapp.com/item/create", param: ["title": self.titleTextField.text!, "description": self.descriptionTextField.text!, "price": self.priceTextField.text!, "user_uid": (GlobalState.user?.id)!])
            }
        }
    }
    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToProfile", sender: self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func AddImageButtonClicked(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false // If you want to let the users allow to use video.
        UIApplication.shared.isStatusBarHidden = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func imageTapped(_ gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if self.mode == "EditingExisting" {
            return
        }
        
        if (gesture.view as? UIImageView) != nil {
            let fusuma = FusumaViewController()
            fusuma.delegate = self
            fusuma.hasVideo = false // If you want to let the users allow to use video.
            UIApplication.shared.isStatusBarHidden = true
            self.present(fusuma, animated: true, completion: nil)
        }
    }
    
    func setMode() {
        if self.item != nil {
            self.mode = "EditingExisting"
        } else {
            self.mode = "EditingNew"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.mode == "EditingExisting" {
            self.addImageButton.isHidden = true
            self.image.downloadedFrom(link: (self.item?.picture!)!)
            self.titleTextField.text = self.item?.title
            self.descriptionTextField.text = self.item?.description
            self.priceTextField.text = self.item?.price
        }

        // Do any additional setup after loading the view.
        setNavigationBarStyle()
        self.LoaderView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        image.image = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func fusumaImageSelected(_ image: UIImage) {
    }
    
    public func fusumaDismissedWithImage(_ image: UIImage) {
        self.addImageButton.isHidden = true
        self.image.contentMode = .scaleAspectFill
        self.image.image = image
        self.image.contentMode = .scaleAspectFill
        self.image.clipsToBounds = true
    }
    
    public func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    public func fusumaCameraRollUnauthorized() {
    }
    
    func imageUploadRequest(image: UIImage, url: String, param: [String:String]?) {
        let uploadUrl = NSURL(string: url)
        
        let request = NSMutableURLRequest(url:uploadUrl as! URL);
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        //myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            if let data = data {
                
                // You can print out response object
                print("******* response = \(response)")
                
                print(data.count)
                // you can use data here
                
                // Print out reponse body
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                
                self.LoaderView.isHidden = true
                (UIApplication.shared.delegate as! AppDelegate).loadItems(unwindSegue: self, identifier: "unwindToProfile", toggleReload: false)
                
            } else if let error = error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func setNavigationBarStyle() {
        self.navigationBar.barTintColor = UIColor.primary()
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
