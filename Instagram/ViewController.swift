//
//  ViewController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-09-10.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 130).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
    }

}

