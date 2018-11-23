//
//  CommentsController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-18.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CommentsController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var post : Post?
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellID)
        
        fetchComments()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentsCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    let commentTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment"
        return textField
    }()
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        
        containerView.addSubview(commentTextField)
        containerView.addSubview(submitButton)
        
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
         commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    //empty comments array
    var comments = [Comment]()
    fileprivate func fetchComments(){
        guard let postId = self.post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)
        //To observe that value, use ref.observe with datatype and snapshot value
        ref.observe(.childAdded, with: { (snapshot) in
            //snapshot.value is the dictionary values of comments.child by postID
            
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            //Within each comment node, we have creationDate aswell as UID. That uid can then be used to fetch the profilfeimageURl associated with that UID
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUserwithUID(uid: uid, completion: { (user) in
                
                //Once we run this completionBlock , we now have access to user
                //Remember this logic. Each node creates a userID. Firebase can fetch the user with that userID
                
                var comment = Comment(user: user, dictionary: dictionary)
                
                self.comments.append(comment)
                self.collectionView?.reloadData()
                
            })
            
        }) { (err) in
            print("Failed to observe comments")
        }
    }
    //Every page inside iOS app has an inputAccessoryView
    //
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    
    
    @objc func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("post id:", self.post?.id ?? "")
        
        print("Inserting comment:", commentTextField.text ?? "")
        
        let postId = self.post?.id ?? ""
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            
            print("Successfully inserted comment.")
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    
}
