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
