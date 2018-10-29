//
//  UserProfilePhotoCell.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-28.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    //Initializing a CollectionViewCell
    
    //This CollectionView contains an imageView with a background color, it is initialized and added to the viewdidLoad which is the init method by adding a subView
    //By using the post we see if any changes were made to the dictionary post
    var post : Post? {
        //If the properties of the variables in the post Struct change, then we use the didSet function
        didSet {
            
            print(1)
            
            guard let imageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(url: imageUrl)
            guard let url = URL(string: imageUrl) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Failed to fetch ImageURLs")
                    return
                }
                //If the url loaded here is not the same as the imageURL from post, then dont proceed further
                //Once we run the URLSession, it will load the Url in a longer time because it is being run on async
                if url.absoluteString != self.post?.imageUrl {
                    return
                }
                
                guard let imageData = data else {return}
                
                let photoImage = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.photoImageView.image = photoImage
                }
                
            }.resume()
        }
        
    }
    
    
    
    
    
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
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
