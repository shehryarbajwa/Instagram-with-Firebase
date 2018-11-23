//
//  Comment.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation

struct Comment {
    
    var user : User?
    
    let text:String
    let uid:String
    
    //initializer will take in the dictionary values during reference call
    init(user: User, dictionary: [String:Any]) {
        //comment model is no longer going to be initialized without an empty user so with each call of thsi struct it needs to have a user called
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
}
