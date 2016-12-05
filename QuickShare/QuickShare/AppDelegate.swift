//
//  AppDelegate.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 11/21/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
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

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}


extension UIColor {
    class func primary() -> UIColor {
        return UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(159 / 255.0), blue: CGFloat(183 / 255.0), alpha: CGFloat(1))
    }
    
    class func secondary() -> UIColor {
        return UIColor(red: CGFloat(241 / 255.0), green: CGFloat(241 / 255.0), blue: CGFloat(243 / 255.0), alpha: CGFloat(1))
    }
}

struct GlobalState {
    static var user: User? = nil
    static var items: [Item] = []
}

/* Extension to load image from URL into UIImageView
 * Source: http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
 */
extension UIImageView {
    func downloadedFrom(url: URL) {
        contentMode = .scaleAspectFill
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

