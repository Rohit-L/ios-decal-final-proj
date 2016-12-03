//
//  FBLoginViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/2/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        
        if ((FBSDKAccessToken.current()) != nil) {
            print("YOU ARE LOGGED IN")
        }
        
        let loginButton = FBSDKLoginButton.init()
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.primary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Appeared!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (!result.isCancelled) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LoggedOut")
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
