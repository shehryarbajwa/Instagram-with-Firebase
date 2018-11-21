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
        collectionView?.backgroundColor = .red
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellID)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
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
    //Every page inside iOS app has an inputAccessoryView
    //
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    
    
    @objc func handleSubmit(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let postID = post?.id else {return}
        print("postID :\(postID)")
        guard let commenttext = commentTextField.text else {return}
        print("Printing comment from :\(commenttext)")
        
        let postId = postID
        let values = ["text" : commenttext , "creationDate" : Date().timeIntervalSince1970, "uid" : uid] as [String : Any]
        //Reference.child creates the child node comments, which then has another child called postID which is being fetched from the post
        
        Database.database().reference().child("comments").childByAutoId().child(postId).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Couldn't update the comments DB :\(err)")
                return
            }
            
            print("successfully added comment")
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}
