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
        //
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
        
        //We make image to be the selectedImage
        //We choose the uploadData to be a JPEG Image
        //We create a filename for it to be used in the Firebase storage.
        //We use the putData builtin method to upload this data to Firebase Storage
        //We call the downloadURL method from StorageReference
        
        //Step1: Make sure the caption is not empty!
        guard let caption = textView.text, !caption.isEmpty else { return }
        //Unwrap the selectedImage
        guard let image = selectedImage else { return }
        //Upload the image in JPEG format
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        //The filename that you want to store the posts under
        let filename = NSUUID().uuidString
        //Access storage and put the child in storage titled posts
        //Use putData to upload the image
        //Create a child in Storage named posts
        //We are saving the images in stroage which is according to the use of storage vs Firebase Database. By creating a child posts we use /posts in Firebase. We save them with the filename which is randomized each time we save an image url
        //storageRef.downloadURL downloads that URL and then uploads that url to Database
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            
            //Save the URL in Firebase and then save this in the Database. Our job of adding an image is done to Storage. Now we upload this iamge to DB for used as a dictionary in JSON format
            //
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
            
             print("Successfully uploaded post image:")
            
               self.savetoDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
    
    fileprivate func savetoDatabaseWithImageUrl(imageUrl: String){
        
        //The Firebase Realtime Database stores JSON application data, like game state or chat messages, and synchronizes changes instantly across all connected devices.
        
        //Firebase Remote Config stores developer-specified key-value pairs to change the behavior and appearance of your app without requiring users to download an update.
        
        //Firebase Hosting hosts the HTML, CSS, and JavaScript for your website as well as other developer-provided assets like graphics, fonts, and icons.
            
         //   Firebase Storage stores files such as images, videos, and audio as well as other user-generated content
        
        //For Storing images, videos and audio, Storage is useful. For game state or chat messages and Json application data Database is used. In our app, we uploadImages to Storage and text to Database aswell as the imageURL.
        
        //Realtime database store data only json format and it is specially used in app where data is synchronized concurrently like ola app(user location),sensex(Nifty) app where data not persist .
        
        //*Firebase Storage just only store data like memory card.It is specially used for store backend data of app.
        
        guard let postImage = selectedImage else { return }
       guard let caption = textView.text else { return }
        
        //Use uid to authenticate the current user
        //Create a posts reference with the currentUserID
        //
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //Create posts within database with each UID
        let userPostRef = Database.database().reference().child("posts").child(uid)
        //childByAutoId generates a new child location using a unique key and returns a FIRDatabaseReference to it. This is useful when the children of a Firebase Database location represent a list of items.
        let ref = userPostRef.childByAutoId()
        //Values refers to the dictionary JSON which we create. We create imageWidth, caption, imageWidth to be the image's diwth. The date to be the timeIntervalSince 1970
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]

        //Update childValues with the above Values dictionary. This is all jSON data. This is how you create jSON data and this is the data that you can use to run algorithms on
        
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }

            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>)
        }
    }
    
        override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
}
