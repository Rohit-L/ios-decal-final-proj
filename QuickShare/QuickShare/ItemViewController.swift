//
//  ItemViewController.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/1/16.
//  Copyright © 2016 Rohit. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var item: Item?

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemViewNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Item"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.itemImage.downloadedFrom(link: (item?.picture)!)
        self.itemImage.downloadedFrom(link: (item?.picture)!)
        self.sellerName.text = item?.userName
        self.itemPrice.text = "$" + String(format: "%.2f", (item?.price)!)
        self.itemViewNum.text = "Viewed " + String((item?.viewNum)!) + " times"
        self.titleLabel.text = item?.title
        self.descriptionLabel.text = item?.description
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
