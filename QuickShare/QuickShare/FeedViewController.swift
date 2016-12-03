//
//  FirstViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 11/21/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Set status bar for entire application
        //let vc = FBLoginViewController()
        //self.present(vc, animated: false, completion: nil)
        
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor.primary()
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(view)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.primary()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.tabBarController?.tabBar.barTintColor = UIColor.secondary()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        
        // set selected background color of tab bar
        let tabBar = self.tabBarController?.tabBar
        let numberOfItems = CGFloat((tabBar?.items!.count)!)
        let tabBarItemSize = CGSize(width: (tabBar?.frame.width)! / numberOfItems, height: (tabBar?.frame.height)!)
        tabBar?.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.primary(), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        // remove default border
        tabBar?.frame.size.width = self.view.frame.width + 4
        tabBar?.frame.origin.x = -2
        
        searchBar.placeholder = "Search for a specific item."
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        self.title = "Feed"
        self.view.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tabBarItem.title = "Feed"
        
        Just.get("https://quickshareios.herokuapp.com/item/read") { r in
            if r.ok { /* success! */
                let data = r.text?.data(using: .utf8)!
                let json = try? JSONSerialization.jsonObject(with: data!) as! [Any]
                print(json?.count == 2)
                var i = 0
                while i < (json?.count)! {
                    let item = json?[i] as! [String:Any]
                    self.titles.append(item["title"]! as! String)
                    self.descriptions.append(item["description"]! as! String)
                    i += 1
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })

            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* TableView Delegate Methods */
    var titles: [String] = []
    var descriptions: [String] = []
    
    let cellReuseIdentifier = "cell"
    @IBOutlet var tableView: UITableView!
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ItemTableViewCell
        cell.product.downloadedFrom(link: "https://cdn.pixabay.com/photo/2013/10/02/15/51/tree-189852_1280.jpg")
        cell.label.text = self.titles[indexPath.row]
        cell.productDescription.text = self.descriptions[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("You tapped cell number \(indexPath.row).")
    }
    
    /* SearchBar Delegate Methods */
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

}

