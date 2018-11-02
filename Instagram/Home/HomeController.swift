//
//  HomeController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-02.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import Firebase

class HomeController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    //CollectionView has to use the property cellforItem at
    //Then you can register different cells for the collectionView
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
        
        cell.post = Posts[indexPath.item]
        
        return cell
    }
    
    var Posts = [Post]()
    
    fileprivate func fetchPosts(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            
            
            dictionaries.forEach({ (key, value) in
               
                guard let dictionary = value as? [String:Any] else {return}
                
                guard let imageURL = dictionary["imageUrl"] as? String else {return}
                print("imageURL: \(imageURL)")
                
                
                let post = Post(dictionary: dictionary)
                self.Posts.append(post)
                
                
            })
            
            self.collectionView?.reloadData()
            
            
            
        }
        
        
    }
}

