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
    var price: Double
    var viewNum: Int
    var userName: String
    var uid: String
    var picture: String
    
    init(title: String, description: String, price: Double, picture: String, viewNum: Int, userName: String, uid: String) {
        self.title = title
        self.description = description
        self.price = price
        self.viewNum = viewNum
        self.userName = userName
        self.uid = uid
        self.picture = picture
    }
}
