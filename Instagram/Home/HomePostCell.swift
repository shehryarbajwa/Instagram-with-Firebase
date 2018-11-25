//
//  HomePostCell.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-02.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

//This cell renders the entirePost
//This right here is an individual cell being created rather than having a collectionViewController. CollectionViewController then contains different cells to display different information

//Super important. Delegate is a one-to-one viewController relationship. It is not like Notifications. Is it generally considered best practise to reduce the coupling or dependencies between classes in your application. A key benefit is that your code becomes easier to maintain since a change in one class is less likely to impact another dependent class.
//The concept of delegation as its name suggests allows an object to send a message to another object (the delegate) so that it can customise the handling of an event.
//Delegates are one-to-one information sharing object while notifications are one-to-many

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate : HomePostCellDelegate?
    //This is where we will add different items to the cell
    
    let userProfileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    
    
    
    var post : Post? {
        didSet {
            //This is called each time the 
            guard let postImageUrl = post?.imageUrl else {return}
            
            likeButton.setImage(post?.hasliked == true ? UIImage(named: "liked_selected")?.withRenderingMode(.alwaysOriginal): UIImage(named: "liked_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            //We set the usernameLabel to be the post's username that we import from Firebase
            photoImageView.loadImage(urlString: postImageUrl)
            usernameLabel.text = post?.user?.username
            
            guard let profileImageUrl = post?.user?.profileImageUrl else {return}
            
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            captionLabel.text = post?.caption
            
            setupAttributedCaption()
            
        }
    }
    
    fileprivate func setupAttributedCaption(){
        
        guard let post = self.post else { return }
        
        guard let username = post.user?.username else {return}
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        
        
        //This will give two lines between the last text and the new text
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeagoDisplay = post.creationDate.timeAgoDisplay()
        
        attributedText.append(NSAttributedString(string: timeagoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        
        self.captionLabel.attributedText = attributedText
    }
    
    
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let optionsButton : UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let ribbonButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel : UILabel = {
        let label = UILabel()
        
        
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("Loading data")
        
        backgroundColor = .white
        
        addSubview(photoImageView)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        //To get the circleView for an imageView you set a layer and its cornerRadius
        
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //By doing this the photoImageView becomes squared because the height and the width are now equal
        
        
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func setupActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton , commentButton , sendButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        addSubview(ribbonButton)
        ribbonButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
    }
    
    @objc func handleLike(){
        print("Like button set")
        delegate?.didLike(for: self)
        
    }
    
    @objc func handleComment(){
        //First it handles the object, then sends a message to whatever class you want to use it in
        //The delegation also allows you to figure out which item you are clicking on in your ViewController
        //It is also important to know which comments button from what post is being clicked on
        
        print("Handling comments")
        
        guard let post = self.post else {return}
        delegate?.didTapComment(post: post)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
