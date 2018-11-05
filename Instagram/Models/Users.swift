//
//  Users.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-04.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation


struct User {
    
    //Every user has to have uid, which is how it identifies the current user who has logged in
    let username: String
    let profileImageUrl: String
    let uid : String
    
    init(uid: String, dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
        self.uid = uid
    }
}
