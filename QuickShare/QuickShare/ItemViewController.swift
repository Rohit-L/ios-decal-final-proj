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
    @IBOutlet weak var sellerEmail: UIButton!
    @IBOutlet weak var viewNumActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func emailTapped(_ sender: Any) {
        let email = sellerEmail.titleLabel?.text!
        let urlString = "mailto:\(email!)"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Item"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (item?.isFB)! {
            UIApplication.shared.open(NSURL(string: "https://www.facebook.com/" + (item?.post_id)!)! as URL, options: [:], completionHandler: nil)
        }
        
        Just.post("https://quickshareios.herokuapp.com/item/increment", params: ["item_id": (item?.item_id)!], data: [:]) { r in
            if r.ok {
                let data = r.text?.data(using: .utf8)!
                let item = try? JSONSerialization.jsonObject(with: data!) as! [String: Any]
                if item != nil {
                    
                    let viewNum = item?["viewNum"] as! Int
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.viewNumActivityIndicator.stopAnimating()
                        self.itemViewNum.text = "Viewed " + String(viewNum) + " times"
                        self.item?.viewNum = viewNum
                    })

                }

            }
        }
        
        self.itemViewNum.text = ""
        
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

        //self.itemViewNum.text = "Viewed " + String((item?.viewNum)!) + " times"
        self.titleLabel.text = item?.title
        self.descriptionLabel.text = item?.description
        self.sellerEmail.setTitle(item?.email, for: .normal)
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
