//
//  FirstViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 11/21/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import RevealingSplashView

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    var splashView: RevealingSplashView?
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        (UIApplication.shared.delegate as! AppDelegate).feedVC = self
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
        // Set status bar for entire application
        if ((FBSDKAccessToken.current()) == nil) {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "login")
            self.present(vc, animated: true, completion: nil)
        }
        if GlobalState.items.count == 0 {
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
            splashView = RevealingSplashView(iconImage: UIImage(named: "iconSmall")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.094, green:0.624, blue:0.710, alpha:1.0))
            splashView?.animationType = .heartBeat
            let window = UIApplication.shared.keyWindow
            window?.addSubview(splashView!)
            splashView?.startAnimation() {
                print("Completed")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowItemSegue" {
            print("Should perform segue called")
            let cell = sender as! ItemTableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            
            let item: Item
            if self.mode == "normal" {
                item = GlobalState.items[(indexPath?.row)!]
            } else {
                item = self.searchItems[(indexPath?.row)!]
            }
            
            if (item.isFB) {
                UIApplication.shared.open(NSURL(string: "https://www.facebook.com/" + (item.post_id)!)! as URL, options: [:], completionHandler: nil)
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if segue.identifier == "ShowItemSegue" {
            let cell = sender as! ItemTableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            if self.mode == "normal" {
                (segue.destination as! ItemViewController).item = GlobalState.items[(indexPath?.row)!]
            } else {
                (segue.destination as! ItemViewController).item = self.searchItems[(indexPath?.row)!]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView Delegate Methods
    
    let cellReuseIdentifier = "cell"
    @IBOutlet var tableView: UITableView!
    
    var searchItems: [Item] = []
    var mode: String = "normal"
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode == "normal" {
            return GlobalState.items.count
        } else {
            return self.searchItems.count
        }
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ItemTableViewCell
        
        let item: Item
        if self.mode == "normal" {
            item = GlobalState.items[indexPath.row]
        } else {
            item = self.searchItems[indexPath.row]
        }
        
        cell.product.image = nil
        if item.picture != nil {
            cell.product.downloadedFrom(link: item.picture!)
        } else {
            cell.product.image = UIImage(named: "NoImageFound")
        }
        
        cell.label.text = item.title
        cell.productDescription.text = item.description
        
        if item.price.lowercased().range(of: "free") != nil {
            cell.price.text = item.price
        } else {
            if item.price.range(of: "$") != nil {
                cell.price.text = item.price
            } else {
                cell.price.text = "$" + item.price
            }
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        searchBar.text = ""
        setSearch(term: searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setSearch(term: searchBar.text!)
    }
    
    func setSearch(term: String) {
        self.searchItems = []
        if term == "" {
            self.mode = "normal"
        } else {
            self.mode = "search"
            for item in GlobalState.items {
                if item.title.range(of: term) != nil {
                    print(item.title)
                    self.searchItems.append(item)
                }
            }
        }
        self.tableView.reloadData()
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
    
    func reloadData() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.splashView?.heartAttack = true
            self.tableView.reloadData()
        })
    }

}

