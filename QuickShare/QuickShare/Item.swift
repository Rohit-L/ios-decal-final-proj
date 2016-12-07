//
//  Item.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/3/16.
//  Copyright © 2016 Rohit. All rights reserved.
//
class Item {
    var title: String
    var description: String
    var price: String
    var viewNum: Int
    var userName: String
    var uid: String
    var picture: String?
    var isFB: Bool
    var post_id: String?
    var email: String
    var item_id: String?
    
    init(title: String, description: String, price: String, picture: String?, viewNum: Int, userName: String, uid: String, isFB: Bool, post_id: String?, email: String, item_id: Int?) {
        self.title = title
        self.description = description
        self.price = price
        self.viewNum = viewNum
        self.userName = userName
        self.uid = uid
        self.picture = picture
        self.isFB = isFB
        self.post_id = post_id
        self.email = email
        if item_id != nil {
            self.item_id = String(item_id!)
        } else {
            self.item_id = nil
        }
        
    }
}
