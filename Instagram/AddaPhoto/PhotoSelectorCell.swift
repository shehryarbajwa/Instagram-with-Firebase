//
//  PhotoSelectorCell.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-21.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit


class PhotoSelectorCell : UICollectionViewCell {
    
    
    //This is how to create a collectionViewCell. We create objects that allow us to cast these images to our ImageView which contains images.
    //Step1: Declare the UIImageView with a closure. ANd then initialize the iv = ImageView
    //Step2: The contentMode has to be scaleAspectFill
    //Step3: Its clipstoBounds have to be true
    //Step4: Initialize the cell with init(frame: CGRect)
    //Step5: Add the subview into your cell after initializing the cell
    //Step6: Setup its anchor
    //Step 7: Now the cell contains an imageView which contains images
    //Step 8: Once we do this, we will then go into our previous collectionView, register the new collectioNView cell as the collectionViewCell to be used. Once we use this, we will then use the newCollectionCell as the default cell to be used
    //Step 9: Once the images are fetched, we will reload data for the collectionCell and this will display it on the cells
    //Step 10: Set the cell's imageView to be the images we have fetched before
    
    let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        backgroundColor = .brown
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
