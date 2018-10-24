//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-24.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class SharePhotoController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageandTextViews()
        
    }
    
    fileprivate func setupImageandTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        //TopLayoutGuide.bottomAnchor makes the view go all the way touching the top. We use the topanchor to be the bottomAnchor of the topLayout guide
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    
    @objc func handleShare(){
        print("Sharing photo")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
}
