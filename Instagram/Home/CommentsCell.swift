//
//  CommentsCell.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class CommentsCell: UICollectionViewCell {
    
    var comment : Comment? {
        didSet {
            
            guard let comment = comment else {return}
            
            guard let username = comment.user?.username else {return}
            
            let attributedString = NSMutableAttributedString(string: username, attributes: [kCTFontAttributeName as NSAttributedString.Key : UIFont.boldSystemFont(ofSize: 14)])
            guard let profileImage = comment.user?.profileImageUrl else {return}
            
            attributedString.append(NSAttributedString(string: " " + comment.text, attributes: [kCTFontAttributeName as NSAttributedString.Key : UIFont.systemFont(ofSize: 14)]))
            
            textLabel.attributedText = attributedString
            
            profileImageView.loadImage(urlString: profileImage)
        }
    }
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
        
    }()
    //Create an imageView based off the imageView class we have declared before
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Create a cell class
    //Register it in the controller
    //Set up properties numberofItems and cellforitemAt in the COntroller
    //Deque cell with identifier and cast it to collectionViewCell class
    //Declare UICollectionViewFlowLayoutDelegate
    //Then select sizeforItematIndexPath
    //Select the view.width to be width
    //Fix Insets if they arise
    
    
    
    
    
}
