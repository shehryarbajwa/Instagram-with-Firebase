//
//  ViewController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-09-10.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Creating a PhotoButton using closures
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handlePlusPhoto(){
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        present(imagepickercontroller, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    let emailTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        textfield.addTarget(self, action: #selector(changecolor), for: .editingChanged)
        return textfield
    }()
    
    @objc func changecolor(){
        
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 230)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
        
    }
    
    let userNameTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.placeholder = "Username"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(changecolor), for: .editingChanged)
        return textfield
    }()
    let passwordTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textfield.addTarget(self, action: #selector(changecolor), for: .editingChanged)
        return textfield
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handlesignup), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handlesignup(){
        
        guard let email = emailTextField.text else {return}
        guard let username = userNameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("failed to create a user")
                return
            }
            
            print("successfully created user", user?.user.uid ?? "" )
            
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            
            
            Storage.storage().reference().child("profile_image").putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("failed to upload image")
                    return
                }
                
                let profileimageURL = metadata?.storageReference?.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("failed to upload image to metadata")
                    }
                    
                    guard let profileimageurl = (url as? URL)?.absoluteString else {return}
                })
                
                print("Successfuly uploaded image")
            })
            
//            guard let uid = user?.user.uid else {return}
//            let values = [uid : 1]
//            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
//                if let err = err {
//                    print("Failed to save userinfo into db:" , err)
//                }
//
//                print("Successfuly saved the user to database")
//            })
//
//
//        }
        
    }
    }
    
    
    //Adding the view to viewDidLoad and adding contraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)

        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        
    }
    //Add a vertical stackView
    fileprivate func setupInputFields() {
        

        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        

        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }

}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
}

