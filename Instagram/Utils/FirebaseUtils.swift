//
//  FirebaseUtils.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-04.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserwithUID(uid: String, completion: @escaping(User) -> () ){
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String:Any] else {return}
            //The users reference will fetch the users value from Firebase and then fetch the values of the profileImageURl and the username
            
            //The user struct is then initialized with the snapshot value from the JSON call from firebase and initialized
            
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            //The completionhandler takes in input User and
            completion(user)
            
            //Ref for posts accesses the Firebase Posts
            
            //self.fetchpostswithuser(user: user)
            
        }) { (err) in
            print("Failed to fetch user for post:" , err)
            
        }
    }
}
