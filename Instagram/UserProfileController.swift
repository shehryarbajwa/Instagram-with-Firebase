//
//  UserProfileController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-09.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class UserProfile : UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
    }
    
    fileprivate func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            
            let dictionary = snapshot.value as? [String:Any]
            let username = dictionary?["username"] as? String
            self.navigationItem.title = username
        }
        
    }
}
