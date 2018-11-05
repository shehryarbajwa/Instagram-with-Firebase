//
//  HomeController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-02.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import Firebase


//Extension of Database, This will contain the function. We are extending the functionality of the Database Firebase framework. This can be done on pre existing libraries. We will be calling this function to fetchUserswithUID.






class HomeController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let imageUrl = "imageUrl"
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        //For creating custom cells in the homenewsfeed which will contain the posts
        //We create a collectionViewController which then contains collectionViewCells to display different things. Good design pattern
        
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        
        fetchPosts()
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Posts.count
    }
    //Can be used withFlowLayout Delegate method
    //Size for item at determines how big you want the cell's height to be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //By giving the 40 that is the height of the userprofileImageview, and the 8 and 8 are the heights for the top anchor and the bottom anchor
        //It is then incremented with view.frame.width
        
        //THIS IS SUPERIMPORTANT FOR CELLSPACING. BY CREATING HEIGHT, WE SET THE HEIGHT FOR EACH VARIABLE WITHIN THE CELL
        
        var height : CGFloat = 40 + 8 + 8 // username and userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    //CollectionView has to use the property cellforItem at
    //Then you can register different cells for the collectionView
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
        //cell.post runs on each indexPath's item. It starts with 0, then 1 then 2 etc.
        //The value of post is changed with each IndexPath Item.
        //Posts[indexPath.item] means what is the value of imageURL at key 0, then 1 then 2 etc.
        //This changes the post Variable in HomePostcell and notifies it which then marks when values are changed.
        cell.post = Posts[indexPath.item]
        
        return cell
    }
    //Posts is the empty array of imageURL's
    var Posts = [Post]()
    
    fileprivate func fetchPosts(){
        
        //In the fetching of Posts we can then initialize the Post and User Library with the values imported from Firebase
        
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //We use the completionBlock within fetchUserwithUID so that we can fetchpostswithuser once we make the Firebase network requests aswell as the
        
        Database.fetchUserwithUID(uid: uid) { (user) in
            self.fetchpostswithuser(user: user)
        }
    }
    
    
    fileprivate func fetchpostswithuser(user: User){
        
        
        
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            //dictionaries refers to the values of caption, creationDate, Height
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            
            //For each accesses just the imageURL
            dictionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String:Any] else {return}
                
                guard let imageURL = dictionary[self.imageUrl] as? String else {return}
                
                let post = Post(user: user, dictionary: dictionary)
                self.Posts.append(post)
                
                
            })
            
            self.collectionView?.reloadData()
            
            
            
        }
    }
}

