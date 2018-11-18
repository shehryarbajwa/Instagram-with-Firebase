//
//  CommentsController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-18.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class CommentsController : UICollectionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .red
        
        
    }
    
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
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            
            let submitButton = UIButton(type: .system)
            submitButton.setTitle("Submit", for: .normal)
            submitButton.setTitleColor(.black, for: .normal)
            submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            
            let textField = UITextField()
            textField.placeholder = "Enter Comment"
            containerView.addSubview(textField)
            containerView.addSubview(submitButton)
            
            submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
            
            textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}
