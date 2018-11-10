//
//  Posts.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-28.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation


struct Post {
    //Add the user and the caption in the Post struct aswell
    
    let imageUrl : String
    let user : User?
    let caption : String
    let creationDate : Date
    
    
    //Initialized with a dictionary so its initial value is a dictionary whcih then contains values. Basically this struct is a dictionary
    //The dictionary is initialized with the user and the caption
    init(user: User , dictionary : [String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsfrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsfrom1970)
        
        
        
    }
}
