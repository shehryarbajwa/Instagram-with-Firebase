//
//  Posts.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-28.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation


struct Post {
    let imageUrl : String
    
    //Initialized with a dictionary so its initial value is a dictionary whcih then contains values. Basically this struct is a dictionary
    init(dictionary : [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        
        
    }
}