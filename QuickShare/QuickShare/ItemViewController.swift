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
    @IBOutlet weak var sellerEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Item"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (item?.isFB)! {
            UIApplication.shared.open(NSURL(string: "https://www.facebook.com/" + (item?.post_id)!)! as URL, options: [:], completionHandler: nil)
        }
        
        if (item?.picture) != nil {
          self.itemImage.downloadedFrom(link: (item?.picture)!)
        } else {
            self.itemImage.image = UIImage(named: "NoImageFound")
        }
        
        self.sellerName.text = item?.userName
        
        
        if item?.price.lowercased().range(of: "free") != nil {
            self.itemPrice.text = item?.price
        } else {
            if item?.price.range(of: "$") != nil {
                self.itemPrice.text = item?.price
            } else {
                self.itemPrice.text = "$" + (item?.price)!
            }
        }

        self.itemViewNum.text = "Viewed " + String((item?.viewNum)!) + " times"
        self.titleLabel.text = item?.title
        self.descriptionLabel.text = item?.description
        self.sellerEmail.text = item?.email
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
