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






class HomeController : UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    
    func didLike(for cell: HomePostCell) {
        //The indexPath returns the collectionView's indexPath that is selected
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        var posts = self.Posts[indexPath.item]
        print(posts.caption)
        guard let postid = posts.id else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = [uid: posts.hasliked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postid).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to like posts \(err)")
                return
            }
            print("Successfuly liked posts")
            
            posts.hasliked = !posts.hasliked
            
            self.Posts[indexPath.item] = posts
            
            self.collectionView?.reloadItems(at: [indexPath])
        }
        print("Handling like inside of Controller")
    }
    
    func didTapComment(post: Post) {
        print("Message coming from HomepostCell")
        //print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        //Once a post is clicked on, we can then take the reference from the Post Struct and then allow this post to be used in CommentsController
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
        //Once we get this information, we can then ask the viewController to push another ViewController on the stack of ViewControllers
    }
    
   
    
    
    
    
    
    
    
    
    
    let imageUrl = "imageUrl"
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatefeed), name: SharePhotoController.updateFeedNotification, object: nil)
        
        collectionView?.backgroundColor = .white
        //For creating custom cells in the homenewsfeed which will contain the posts
        //We create a collectionViewController which then contains collectionViewCells to display different things. Good design pattern
        
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        //Added the refresh control
        //Then added a target which is handleRefresh which is just fetching posts again
        //It allows the collectionView to refresh its Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        fetchAllposts()
        setupNavigationBar()
        
    }
    
    @objc func handleRefresh(){
        fetchAllposts()
        Posts.removeAll()
    }
    
    @objc func handleUpdatefeed(){
        handleRefresh()
    }
    
    fileprivate func fetchAllposts(){
        fetchPosts()
        fetchFollowinguserID()
    }
    
    fileprivate func fetchFollowinguserID(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let userIdsDictionary = snapshot.value as? [String:Any] else {return}
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserwithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch following users :\(err)")
        }
    }
    
    func setupNavigationBar(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), landscapeImagePhone: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera(){
        print("Showcasing camera")
        let cameraController = CameraController()
        //Once the camera button is pushed, we use CATransition
        //An object that provides an animated transition between a layer's states.
        //transitions duration is 0.30
        //transitions type is transitionPush, could be fade, move in, reveal
        //Further, the subtype denotes how to present the subview
        //Then just add to the layer and you are done
        let transition = CATransition()
        transition.duration = 0.30
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
            
        present(cameraController, animated: false)
        
        
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
        
        cell.post = Posts[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    //Posts is the empty array of imageURL's
    var Posts = [Post]()
    
    fileprivate func fetchPosts(){
        
        //In the fetching of Posts we can then initialize the Post and User Library with the values imported from Firebase
        
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //We use the completionBlock within fetchUserwithUID so that we can fetchpostswithuser once we make the Firebase network requests aswell as the
        
        Database.fetchUserwithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasliked = true
                    } else {
                        post.hasliked = false
                    }
                    
                    self.Posts.append(post)
                    self.Posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                })
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
        
        
        
       
        
        
    }


