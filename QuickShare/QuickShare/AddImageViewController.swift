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

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
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
        if (gesture.view as? UIImageView) != nil {
            let fusuma = FusumaViewController()
            fusuma.delegate = self
            fusuma.hasVideo = false // If you want to let the users allow to use video.
            UIApplication.shared.isStatusBarHidden = true
            self.present(fusuma, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func fusumaImageSelected(_ image: UIImage) {
        print("Image selected")
    }
    
    public func fusumaDismissedWithImage(_ image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
        self.addImageButton.isHidden = true
        self.image.image = image
        self.image.contentMode = .scaleAspectFill
        self.image.clipsToBounds = true
        //imageUploadRequest(image: image, url: "https://quickshareios.herokuapp.com/image/upload", param: ["Hello": "World"])
    }
    
    public func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Video Completed")
    }
    
    public func fusumaCameraRollUnauthorized() {
        print("Unauthorized Camera Roll")
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
                
                //let json =  try!JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                //print("json value \(json)")
                
                //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                
//                DispatchQueue.main.asynchronously(execute: {
//                    //self.myActivityIndicator.stopAnimating()
//                    //self.imageView.image = nil;
//                });
                
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
