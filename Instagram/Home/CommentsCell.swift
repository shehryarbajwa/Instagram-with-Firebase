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
            
            textLabel.text = comment?.text
        }
    }
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
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
