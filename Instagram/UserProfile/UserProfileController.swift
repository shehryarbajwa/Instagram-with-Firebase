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

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    var isGridView = true
    
    func didChangetoListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    func didChangetoGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    
    
    var UserID : String?
    let homePostCell = "homePostcellID"
    let cellId = "cellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()
        
        
        
        //Use the collectionView to register the ProfileHeader and the supplementaryViewofKind is UICollection.ElementKindSectionHeader with reUseIdentifier headerID. The header is the upperPart of the CollectionView.
        
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCell)
        setUpLogout()
        
        //fetchPosts()
        
    }
    //Create an array which is empty which contains the value of the posts
    var isFinishedPaging = false
    var Posts = [Post]()
    
    fileprivate func paginatePosts() {
        print("Start paging for more posts")
        
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        //        let value = "-Kh0B6AleC8OgIF-mZNT"
        //        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 6)
        
        //        var query = ref.queryOrderedByKey()
        
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if Posts.count > 0 {
            //            let value = posts.last?.id
            let value = Posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.Posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else { return }
            
            allObjects.forEach({ (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                
                self.Posts.append(post)
                
                //                print(snapshot.key)
            })
            
            self.Posts.forEach({ (post) in
                print(post.id ?? "")
            })
            
            self.collectionView?.reloadData()
            
            
        }) { (err) in
            print("Failed to paginate for posts:", err)
        }
    }
    
    
    fileprivate func fetchOrderedPosts(){
        
        //This now reflects the uid for the indexPath item
        guard let uid = self.user?.uid else {return}
        
        
        
        let ref = Database.database().reference().child("posts").child(uid)
        //Fetch Orderered posts is observing the child "posts" "childAdded"
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            print(snapshot.key , snapshot.value)
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            guard let user = self.user else {return}
            
            let post = Post(user: user, dictionary: dictionary)
            self.Posts.insert(post, at: 0)
            
            //self.Posts.append(post)
            
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch ordered posts : \(err)")
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
        
        //how to fire off the paginate call?
        if indexPath.item == self.Posts.count - 1 && !isFinishedPaging {
            print("Paginating for pots")
            self.paginatePosts()
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            
            //cell.post refers to the post variable we created earlier which refers to the Post struct. Its value refers to the array Posts each numbered from the indexPath
            //The posts struct contains the imageURl from our dictionary
            //Previously the Posts struct was empty. It started getting values once we observed the Firebase Database and
            cell.post = Posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCell, for: indexPath)as! HomePostCell
            cell.post = Posts[indexPath.item]
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height : CGFloat = 40 + 8 + 8 // username and userprofileimageview
            height += view.frame.width
            height += 50
            height += 60
            
            return CGSize(width: view.frame.width, height: height)
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Posts.count
    }
    
    //Setup the SupplementatyView in the same way you set up the collectioNView normally
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //Fetch the user information from Firebase and check out what the snapshot refers to. Go to database, child of users and observe the single event of value. Then set the navigationItem's title to self.user?.username
    
    
    var user: User?
    fileprivate func fetchUser() {
        
        //This will determine whether the uid has been changed in the userID
        
        let uid = UserID ?? Auth.auth().currentUser?.uid ?? ""
        
       // guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserwithUID(uid: uid) { (user) in
            //Once we have the existing user's uid, then we assign this user to our user variable declared above, which is then employed by fetchOrderedPosts()
            self.user = user
            self.navigationItem.title = self.user?.username
            
            
            //Reload data happens twice. During fetchPosts and fetchUsers
            self.collectionView?.reloadData()
            //First we fetch user with the UserID
            //Once we have this , then we click on fetchOrderedPosts()
            
            self.paginatePosts()
        }
    }
}

//Hold information regarding a user in a struct so this code can be used elsewhere. 


