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

class HomePostCell: UICollectionViewCell {
    
    var post : Post? {
        didSet {
            print(post?.imageUrl)
            //This is called each time the 
            guard let postImageUrl = post?.imageUrl else {return}
            
            
            photoImageView.loadImage(urlString: postImageUrl)
        }
    }
    
    
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
