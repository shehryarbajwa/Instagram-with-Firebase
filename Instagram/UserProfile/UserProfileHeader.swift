//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-13.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import Firebase
import AssetsLibrary

protocol UserProfileHeaderDelegate {
    func didChangetoListView()
    func didChangetoGridView()
}


class UserProfileHeader: UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?
    //
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernamelabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    fileprivate func setupEditFollowButton(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        } else {
            
            // check if following the indexPath user. We observe the following node, then observe the currentLoggedInUserID with the child which has the userID and observe its value.
            //If the snapshot has a value of 1, then it means that the user is following. If the value is not 1, then we just
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                } else {
                    self.setupFollowStyle()
                }
                
            }, withCancel: { (err) in
                print("Failed to check if following: \(err)")
            })
        }
    
    }
        
    @objc func handleEditProfileOrFollow() {
        print("Execute edit profile / follow / unfollow logic...")
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            
            //unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user: \(err)")
                    return
                }
                
                print("Successfully unfollowed user: \(self.user?.username ?? "")")
                
                self.setupFollowStyle()
            })
            
        } else {
            //follow
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user: \(err)")
                    return
                }
                
                print("Successfully followed user: \(self.user?.username ?? "") ")
                
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    
    //Create a profile image
    //Step1:
    //Create a UIImageView which then contains an image
    //It is better to render an image to an imageView so that it becomes easier to apply animation to it
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    //Step2:
    //Creating a UIButton closure that is instantialized by creating a type of UIButton, then declaring that button and finally setting an image to the button for type normal
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangetoGridView), for: .touchUpInside)
        return button
    }()
    //Using the tintcolor allows you to make the color a bit transluscent
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangedtoListView), for: .touchUpInside)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernamelabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //Here, we add a label. The label is utilizing the NSMutableAttributableStringAPI to render the font to be bold, allow foreground color, have its textallignment and add the number of lines
    
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //Same thing here, we add a Label and utilize different AttributedStringAPI methods to change the font type to be bold and
    
    let followersLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    //By using the .layer option, we utilize animation and can then render the object with cornerRadius, with the borderWitdth, and the borderColor
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    //Override init allows you to instantialize the collectionView and initialize using super.init(frame:frame)
    //Within the collectionView, we add subviews to display our data within the collectionViewcell
    //Similarly, within the initialization, we setup the anchors for the editProfileButton, profileImageView, and the username label
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        setupUserStatsView()
        
        
        addSubview(usernamelabel)
        addSubview(editProfileFollowButton)
        
        
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        usernamelabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 25, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        
        
    }
    
    //We setup a stackView to contain the postsLabel, followerslabel and the followinglabel to be included in a stackView. This allows us to arrangetheSubviews in a stackViews. StackViews allow allignment, spacing and spacing. Instead of using the storyboard and making changes, using StackView can help place views in a certain place with anchors. Distribution and allignment properties are used. Add the subView to the collectionView by using addSubview(stackView).
    
    fileprivate func setupUserStatsView(){
        let stackview = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackview.distribution = .fillEqually
        addSubview(stackview)
        stackview.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    //
    
    fileprivate func setupBottomToolbar(){
        
        
        //Creating bottomToolbar so the UI is sleek and clean and adjustable to all screen sizes
        let topDividorView = UIView()
        topDividorView.backgroundColor = UIColor.lightGray
        
        let bottomDividorView = UIView()
        bottomDividorView.backgroundColor = UIColor.lightGray
        
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        addSubview(stackView)
        addSubview(topDividorView)
        addSubview(bottomDividorView)
        
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividorView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividorView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
        stackView.distribution = .fillEqually
        
    }
    
    @objc func handleChangedtoListView(){
        print("Printing listView")
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangetoListView()
        
    }
    
    @objc func handleChangetoGridView(){
        print("Printing GridView")
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangetoGridView()
    }
    
    //Download the profileimage from the user's Firebase Database. You need to select the url from the Firebase database, and then download the datataskwithURL. And then use the main.sync method to be used on the mainThread to cast the image since it involves using the UI. UI Related tasks are to be done on the main thread.
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
