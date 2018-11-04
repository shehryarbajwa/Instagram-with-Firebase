//
//  Users.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-04.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation


struct User {
    
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
