//
//  ProfileViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/2/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    var loginButton: FBSDKLoginButton = FBSDKLoginButton.init()
    
    @IBAction func LogOutAction(_ sender: Any) {
        loginButton.sendActions(for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Profile"
        
        setNavigationBarStyle()
        setTabBarStyle()
        
        loginButton.center = view.center
        loginButton.delegate = self
        
        self.view.backgroundColor = UIColor.primary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (!result.isCancelled) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LoggedOut")
        self.tabBarController?.selectedIndex = 0
    }
    
    /* MARK: Helper Methods */
    func setNavigationBarStyle() {
        self.navigationController?.navigationBar.barTintColor = UIColor.primary()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func setTabBarStyle() {
        let tabBar = self.tabBarController?.tabBar
        
        tabBar?.barTintColor = UIColor.secondary()
        tabBar?.tintColor = UIColor.white
        
        // set selected background color of tab bar
        let numberOfItems = CGFloat((tabBar?.items!.count)!)
        let tabBarItemSize = CGSize(width: (tabBar?.frame.width)! / numberOfItems, height: (tabBar?.frame.height)!)
        tabBar?.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.primary(), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        // remove default border
        tabBar?.frame.size.width = self.view.frame.width + 4
        tabBar?.frame.origin.x = -2
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
