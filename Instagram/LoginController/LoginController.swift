//
//  LoginController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-16.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    let signUpbutton : UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign up", for: .normal)
        button.addTarget(self, action: #selector(handleshowssignup), for: .touchUpInside)
        return button
    }()
    
    @objc func handleshowssignup(){
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(signUpbutton)
        
        navigationController?.isNavigationBarHidden = true
        
        signUpbutton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
}
    
    
}
