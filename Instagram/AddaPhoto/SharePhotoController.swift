//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-24.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController : UIViewController {
    
    
    //This is the view that we create for adding the share ViewController
    //SelectedImage refers to the optional value of UIImage
    
    //
    
    var selectedImage : UIImage? {
        
        //What is this property? DidSet is a property observer that observes the changes in a property's values. They are called each time a value is set for a property. Property observers are declared with var and not let. Once there is a change in the selectedImage we change the imageView's image to be the selectedimage
        didSet {
            print(selectedImage)
            
            self.imageView.image = selectedImage
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        //Add a barButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        //SetUpImageandTextViews
        setupImageandTextViews()
        
    }
    
    var imageView : UIImageView  = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        
        //What is this property?
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageandTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.addSubview(imageView)
        
        //TopLayoutGuide.bottomAnchor makes the view go all the way touching the top. We use the topanchor to be the bottomAnchor of the topLayout guide
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    @objc func handleShare(){
        print("Sharing photo")
        
        //We make image to be the selectedImage
        //We choose the uploadData to be a JPEG Image
        //We create a filename for it to be used in the Firebase storage.
        //We use the putData builtin method to upload this data to Firebase Storage
        
        
        guard let image = selectedImage else {return}
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        
        //Filename is a random string of letters and numbers
        let filename = NSUUID().uuidString
        Storage.storage().reference().child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Failed to upload Image" , err)
                return
            }
            
            StorageReference().downloadURL(completion: { (downloadurl, error) in
                if let error = error {
                    print("Failed to fetch download URL")
                    return
                }
                
                guard let imageurl = downloadurl?.absoluteString else {return}
                
                print("Successfully uploaded image" , imageurl)
                
                //self.savetoDatabaseWithImageUrl(imageUrl: imageurl)
               
                
            })
            
            print("Successfully uploaded post image" )
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
}
