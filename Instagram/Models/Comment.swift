//
//  Comment.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation

struct Comment {
    let text:String
    let uid:String
    
    //initializer will take in the dictionary values during reference call
    init(dictionary: [String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
}
