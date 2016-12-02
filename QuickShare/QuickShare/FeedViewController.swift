//
//  FirstViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 11/21/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set status bar for entire application
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor.red
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(view)
        
        
        self.title = "Feed"
        self.view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tabBarItem.title = "Feed"
        
        
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
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    @IBOutlet var tableView: UITableView!
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ItemTableViewCell
        cell.product.downloadedFrom(link: "https://cdn.pixabay.com/photo/2013/10/02/15/51/tree-189852_1280.jpg")
        //cell.product.backgroundColor = self.colors[indexPath.row]
        cell.label.text = self.animals[indexPath.row]
        cell.productDescription.text = "A cool picture!"
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("You tapped cell number \(indexPath.row).")
    }

}

