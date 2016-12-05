//
//  FirstViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 11/21/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        
        self.title = "Feed"
        view.backgroundColor = UIColor.primary()
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(view)
        
        setNavigationBarStyle()
        setTabBarStyle()
        
        searchBar.placeholder = "Search for a specific item."
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        
        self.view.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Get items from server
        Just.get("https://quickshareios.herokuapp.com/item/read") { r in
            if r.ok { /* success! */
                let data = r.text?.data(using: .utf8)!
                let json = try? JSONSerialization.jsonObject(with: data!) as! [Any]
                
                var i = 0
                while i < (json?.count)! {
                    let item = json?[i] as! [String:Any]
                    let title = item["title"] as! String
                    let description = item["description"] as! String
                    let price = Double(item["price"] as! String)
                    let picture = item["picture"] as! String
                    let viewNum = item["viewNum"] as! Int
                    let userName = (item["user"] as! [String: Any])["name"] as! String
                    let item_uid = item["user_uid"] as! String
                    
                    let itemObject = Item(title: title, description: description, price: price!, picture: picture, viewNum: viewNum, userName: userName, uid: item_uid)
                    GlobalState.items.append(itemObject)
                    i += 1
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })

            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set status bar for entire application
        if ((FBSDKAccessToken.current()) == nil) {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "login")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print("Now Transitioning")
        if segue.identifier == "ShowItemSegue" {
            let cell = sender as! ItemTableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            (segue.destination as! ItemViewController).item = GlobalState.items[(indexPath?.row)!]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView Delegate Methods
    
    let cellReuseIdentifier = "cell"
    @IBOutlet var tableView: UITableView!
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalState.items.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ItemTableViewCell
        let item = GlobalState.items[indexPath.row]
        cell.product.downloadedFrom(link: item.picture)
        cell.label.text = item.title
        cell.productDescription.text = item.description
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("You tapped cell number \(indexPath.row).")
    }
    
    // MARK: SearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: Helper Methods
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

}

