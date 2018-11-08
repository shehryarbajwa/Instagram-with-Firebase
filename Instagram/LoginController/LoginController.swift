//
//  LoginController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-16.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    //We created a UIView which will contain the logo. We instantiateed the UIView and then added an imageView which contained a UIImage. Then we added it to the subview. The content mode of the logo is to be scaleAspectFit/scaletoFill. Then we add the anchoring. We don't set the top or the left bottom or any constraint and just set the height and width. Instead we equal the CenterXAnchor and CenterYAnchor to the View's centerX and CenterY.
    
    
    let logoContainerView : UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: UIImage(named: "instagramlogo"))
        view.addSubview(logoImageView)
        
        logoImageView.contentMode = .scaleToFill
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 75)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let signUpbutton : UIButton = {
       let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14) , NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        
        attributedTitle.append(NSMutableAttributedString(string: " Sign Up", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14) , NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237) ]))
    
        
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitle("Don't have an account? Sign up", for: .normal)
        button.addTarget(self, action: #selector(handleshowssignup), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.placeholder = "Email"
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textfield.resignFirstResponder()
        return textfield
    }()
    
    @objc func changecolor(){
        
    }
    
    let passwordTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textfield.resignFirstResponder()
        return textfield
    }()
    
    let loginButton : UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handlesignup(){
        
    }
    
    //The loginbutton has a target that allows it to handle when a user tries to log into an application. The Auth.auth() feature allows you to sign in via the firebase API for login, password and email address. The mainTabBarController allows you to utilize the UIApplication.shared.keyWindow?.rootViewController as the VC to be used each time a login occurs.
    
    //UIApplication.shared.keyWindow?.rootViewController allows the app to login again and again displaying different data for each unique user.
    
    @objc func handleLogin(){
        
        guard let emailtext = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: emailtext, password: password) { (user, error) in
            if let error = error {
                print("Failed to sign in with the email:", error)
                return
            }
            
            print("Successfully logged back in with user.: " , user?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            
            mainTabBarController.setupViewController()
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    @objc func handleTextInputChange(){
        
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 230)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleshowssignup(){
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(signUpbutton)
        view.addSubview(logoContainerView)
        
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        
        signUpbutton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        setupInputFields()
}
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
    }
    
}
