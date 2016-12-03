//
//  FBLoginViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/2/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
//import FacebookLogin

class FBLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
//        let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
//        loginButton.center = view.center
//        
//        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Appeared!")
//        if let accessToken = AccessToken.current {
//            // User is logged in, use 'accessToken' here.
//            self.dismiss(animated: true, completion: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
