//
//  UserSearchController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-06.
//  Copyright © 2018 Shehryar. All rights reserved.
// Each View should have its own group

import Foundation
import UIKit
import Firebase

class UserSearchController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    let searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 240, blue: 240)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        //After adding the subview then add the cells
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellID)
        
        //Allows the collectionView to bounce vertical
        collectionView?.alwaysBounceVertical = true
        
        fetchUsers()
        
    }
    //To give the cell height, first conform to UICollectionFlowLayoutDelegate
    //Then use sizeforitem at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    
    fileprivate func fetchUsers(){
        
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            
            //Iterates through all of the objects inside the dictionary
            dictionaries.forEach({ (key , value) in

                
                guard let userDictionary = value as? [String:Any] else {return}
                
                let user = User(uid: key, dictionary: userDictionary)
                
                print(user.uid , user.username)
                
            })
            
    
            
            
        }) { (error) in
            print("Failed to fetch users: \(error )")
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        return cell
    }
}
