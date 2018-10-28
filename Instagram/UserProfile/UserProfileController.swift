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

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let cellId = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
        
        //Use the collectionView to register the ProfileHeader and the supplementaryViewofKind is UICollection.ElementKindSectionHeader with reUseIdentifier headerID. The header is the upperPart of the CollectionView.
        
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        setUpLogout()
        
        fetchPosts()
        
    }
    //Create an array which is empty which contains the value of the posts
    var Posts = [Post]()
    
    
    fileprivate func fetchPosts(){
        
        //We are accessing the current user's uid which also takes place in the database's uid
        //Lets inspect the database. Within the database elements there is the child posts, which then has another child called the currentUser which then holds the different data objects
        guard let uid = Auth.auth().currentUser?.uid else {return}
        //By observing the single event of the posts child, we can then print the snapshot's value and print it out
        //This will print all the data that is associated with the profile
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            //We cast the jSon returned data in a dictionary that we can later use
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            
            //Print the key and the values for the dictionary
            dictionaries.forEach({ (key, value) in
                //When we return dictionaries it returns dictionaries for all the users
                //Instead we want it for one user, so we use forEach method
                //Once we iterate over one user's dictionary, we cast it as a single dictionary and then cast that value as a dictionary.
                //Within that dictionary, there is imageURL property that contains the links to the dictionary
                guard let dictionary = value as? [String:Any] else {return}
                
                guard let imageURL = dictionary["imageUrl"] as? String else {return}
                print("imageURL: \(imageURL)")
                
                //We then create a struct Post which contains a dictionary with the value of imageURL
                let post = Post(dictionary: dictionary)
                print(post.imageUrl)
                self.Posts.append(post)
                
                
            })
            
            self.collectionView?.reloadData()
            
            
            
        }
        
        
    }
    
    
    
    fileprivate func setUpLogout(){
        //By keeping renderingMode to be original u keep the image as it is in the assets
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //In the UIAlertAction handler closure, try Auth.auth().signOut() to sign out from Firebase. Do this with a do, catch syntax.
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                //what happens? we need to present some kind of login controller
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            }
            
            catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        
        //cell.post refers to the post variable we created earlier which refers to the Post struct. Its value refers to the array Posts each numbered from the indexPath
        //The posts struct contains the imageURl from our dictionary
        //Previously the Posts struct was empty. It started getting values once we observed the Firebase Database and
        cell.post = Posts[indexPath.item]
        
        cell.backgroundColor = .purple
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Posts.count
    }
    
    //Setup the SupplementatyView in the same way you set up the collectioNView normally
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //Fetch the user information from Firebase and check out what the snapshot refers to. Go to database, child of users and observe the single event of value. Then set the navigationItem's title to self.user?.username
    
    
    var user: User?
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetchuser:", err)
        }
    }
}

//Hold information regarding a user in a struct so this code can be used elsewhere. 

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
