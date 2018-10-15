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


class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            setupProfileImage()
            
            usernamelabel.text = user?.username
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "shehryar")
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
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
        label.text = "Shehryar"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postslabel : UILabel = {
        let label = UILabel()
        label.text = "11/nposts"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followerslabel : UILabel = {
        let label = UILabel()
        label.text = "11/nposts"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followinglabel : UILabel = {
        let label = UILabel()
        label.text = "11/nposts"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
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
        usernamelabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
    }
    
    fileprivate func setupUserStatsView(){
        let stackview = UIStackView(arrangedSubviews: [postslabel, followerslabel, followinglabel])
        stackview.distribution = .fillEqually
        addSubview(stackview)
        stackview.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolbar(){
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        stackView.distribution = .fillEqually
        
    }
    
    
    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        
        guard let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //check for the error, then construct the image using data
            if let err = err {
                print("Failed to fetch profile image:", err)
                return
            }
            
            //perhaps check for response status of 200 (HTTP OK)
            
            guard let data = data else { return }
            
            let image = UIImage(data: data)
            
            //need to get back onto the main UI thread
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
