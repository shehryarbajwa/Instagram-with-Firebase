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
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)
        plusPhotoButton.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        plusPhotoButton.center = view.center
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

