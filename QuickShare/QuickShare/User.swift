//
//  User.swift
//  QuickShare
//
//  Created by Rohit Lalchandani on 12/3/16.
//  Copyright © 2016 Rohit. All rights reserved.
//
class User {
    var name: String
    var picture: String
    var email: String
    var id: String
    
    init(id: String, name: String, picture: String, email: String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.email = email
    }
}
