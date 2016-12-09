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
    var feedVC: FeedViewController? = nil
    var profileVC: ProfileViewController? = nil

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
        
        if GlobalState.doNotReload {
            return
        }
        
        if GlobalState.items.count == 0 {
            loadItems(unwindSegue: nil, identifier: nil, toggleReload: false)
        }
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
    
    func loadItems(unwindSegue: UIViewController?, identifier: String?, toggleReload: Bool) {
        
        GlobalState.items = []
        
        Just.get("https://quickshareios.herokuapp.com/item/read") { r in
            if r.ok { /* success! */
                let data = r.text?.data(using: .utf8)!
                let json = try? JSONSerialization.jsonObject(with: data!) as! [Any]
                var i = 0
                while i < (json?.count)! {
                    
                    let item = json?[i] as! [String:Any]
                    let item_id = item["id"] as! Int
                    let title = item["title"] as! String
                    let description = item["description"] as! String
                    let price = item["price"] as! String
                    let picture = item["picture"] as! String
                    let viewNum = item["viewNum"] as! Int
                    let userName = (item["user"] as! [String: Any])["name"] as! String
                    let email = (item["user"] as! [String: Any])["email"] as! String
                    let item_uid = item["user_uid"] as! String
                    
                    let itemObject = Item(title: title, description: description, price: price, picture: picture, viewNum: viewNum, userName: userName, uid: item_uid, isFB: false, post_id: nil, email: email, item_id: item_id)
                    GlobalState.items.append(itemObject)
                    i += 1
                }
                
                if (GlobalState.isGuest) {
                    self.feedVC?.reloadData()
                }
            }
        }
        if ((FBSDKAccessToken.current()) != nil) {
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
                            
                            /***** Try group ****/
                            let connection = GraphRequestConnection()
                            connection.add(GraphRequest(graphPath: "/266259930135554/feed")) { httpResponse, result in
                                switch result {
                                case .success(let response):
                                    
                                    var postsMap: [String: [String:String]] = [:]
                                    var objectMap: [String: String] = [:]
                                    let posts = response.dictionaryValue?["data"] as! [Any?]
                                    var posts_count: Int = 0
                                    var count: Int = 0
                                    for post in posts {
                                        
                                        if (post as! [String:Any?])["message"] == nil {
                                            continue
                                        }
                                        
                                        let post_id = (post as! [String:Any?])["id"] as! String
                                        
                                        let connection = GraphRequestConnection()
                                        connection.add(GraphRequest(graphPath: "/" + post_id + "?fields=object_id")) { httpResponse, result in
                                            switch result {
                                            case .success(let response):
                                                
                                                let post_id = response.dictionaryValue?["id"] as! String
                                                
                                                if let object_id_test = response.dictionaryValue?["object_id"] {
                                                    let object_id = object_id_test as! String
                                                    
                                                    objectMap[object_id] = post_id
                                                    posts_count += 1
                                                    
                                                    let connection = GraphRequestConnection()
                                                    connection.add(GraphRequest(graphPath: "/" + object_id + "?fields=images")) { httpResponse, result in
                                                        switch result {
                                                        case .success(let response):
                                                            let object_id = response.dictionaryValue?["id"] as! String
                                                            let imageArray = response.dictionaryValue?["images"] as! [Any?]
                                                            let image = imageArray[0] as! [String:Any?]
                                                            let link = image["source"] as! String
                                                            
                                                            let post_id = objectMap[object_id]
                                                            let item = postsMap[post_id!]
                                                            GlobalState.items.insert(Item(title: item!["title"]!, description: item!["description"]!, price: item!["price"]!, picture: link, viewNum: 0, userName: "Facebook", uid: "Facebook", isFB: true, post_id: post_id, email: "", item_id: nil), at: Int(arc4random_uniform(UInt32(GlobalState.items.count))))
                                                            
                                                            if (toggleReload) {
                                                                GlobalState.doNotReload = false
                                                            }
                                                            
                                                            count += 1
                                                      
                                                            if count == posts_count {
                                                                self.feedVC?.reloadData()
                                                                if identifier != nil {
                                                                    unwindSegue?.performSegue(withIdentifier: identifier!, sender: unwindSegue!)
                                                                }
                                                            }
                                                            
                                                        case .failed(let error):
                                                            print("Graph Request Failed: \(error)")
                                                        }
                                                    }
                                                    connection.start()
                                                } else {
                                                    let item = postsMap[post_id]
                                                    GlobalState.items.insert(Item(title: item!["title"]!, description: item!["description"]!, price: item!["price"]!, picture: nil, viewNum: 0, userName: "Facebook", uid: "Facebook", isFB: true, post_id: post_id, email: "", item_id: nil), at: Int(arc4random_uniform(UInt32(GlobalState.items.count))))
                                                }
                                                
                                            case .failed(let error):
                                                print("Graph Request Failed: \(error)")
                                            }
                                        }
                                        connection.start()
                                        
                                        let message = (post as! [String:Any?])["message"] as! String
                                        let messageComponents = message.characters.split{ $0 == "\n" }.map(String.init)
                                        
                                        let title = messageComponents[0]
                                        
                                        let price: String
                                        if messageComponents.count > 1 {
                                            price = messageComponents[1].characters.split{ $0 == "-" }.map(String.init)[0]
                                        } else {
                                            price = "0"
                                        }
                                        
                                        let description: String
                                        if messageComponents.count > 2 {
                                            description = messageComponents[2]
                                        } else {
                                            description = ""
                                        }
                                        
                                        postsMap[post_id] = ["title": title, "price": price, "description": description]
                                    }
                                    
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
                    
                case .failed(let error):
                    print("Graph Request Failed: \(error)")
                }
            }
            connection.start()
        }
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
    static var isGuest: Bool = false
    static var user: User? = nil
    static var items: [Item] = []
    static var doNotReload: Bool = false
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

