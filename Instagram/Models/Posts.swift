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
    let user : User?
    let caption : String
    
    
    //Initialized with a dictionary so its initial value is a dictionary whcih then contains values. Basically this struct is a dictionary
    init(user: User , dictionary : [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        
        
    }
}
