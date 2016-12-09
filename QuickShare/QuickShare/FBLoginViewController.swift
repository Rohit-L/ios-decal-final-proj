//
//  FBLoginViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/2/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Set Background color
        self.view.backgroundColor = UIColor.primary()
        
        // Create and add login button to view
        let loginButton = FBSDKLoginButton.init()
        loginButton.readPermissions = ["public_profile", "email"];
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((FBSDKAccessToken.current()) != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        
        GlobalState.doNotReload = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guestModeRequested(_ sender: Any) {
        GlobalState.isGuest = true
        (UIApplication.shared.delegate as! AppDelegate).loadItems(unwindSegue: nil, identifier: nil, toggleReload: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: FBSDKLoginButtonDelegate Methods
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (!result.isCancelled) {
            
            let connection = GraphRequestConnection()
            connection.add(GraphRequest(graphPath: "me/", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: GraphAPIVersion.defaultVersion)) { httpResponse, result in
                switch result {
                case .success(let response):
                    
                    let email = response.dictionaryValue?["email"] as! String
                    let name = response.dictionaryValue?["name"] as! String
                    let id = response.dictionaryValue?["id"] as! String
                    
                    let connection = GraphRequestConnection()
                    connection.add(GraphRequest(graphPath: "me/picture?type=large&redirect=false")) { httpResponse, result in
                        switch result {
                        case .success(let response):
                            
                            let picture = (response.dictionaryValue?["data"] as! [String: Any?])["url"] as! String
                            GlobalState.user = User(id: id, name: name, picture: picture, email: email)
                            
                            // Send request to create user if user has not already been created
                            let url = "https://quickshareios.herokuapp.com/user/create"
                            Just.post(url, params: ["id": id, "name": name, "email": email], data: [:])
                            (UIApplication.shared.delegate as! AppDelegate).loadItems(unwindSegue: nil, identifier: nil, toggleReload: true)
                            self.dismiss(animated: true, completion: nil)
                        case .failed(let error):
                            print("Graph Request Failed: \(error)")
                        }
                    }
                    connection.start()
                    
                case .failed(let error):
                    print("Graph Request Failed: \(error)")
                }
            }
            connection.start()
        }
    }
    

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        return
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
