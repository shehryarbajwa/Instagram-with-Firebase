//
//  CustomImageViewSubclass.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-29.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class CustomImageView : UIImageView {
    
    //This is a customImageView that allows us to loadImages for the cells
    //Step1: We go into the cells which are calling Images, which are the UserPhotocell and the UserProfileHeader
    //Step2: Instead of having a standard imageView, we use this customImageView class
    //Step3: This class loads an imageData from the urlString
    //Step4: Where is the urlString provided? Within didSet, where you scan in the Post dictionary whether any new imageURL has been added, we load the new Image provided by the function. This goes for both the PhotoCell and the UserprofileHeaderCell. The struct User contains the name and profileImageURl. If there is a change to that struct, we can then use the didSet function on it, observe a change in its value and when that happens, passing it the profileImageURL
    
    
    
    var lasturlusedtoloadImage : String?
    
    func loadImage(urlString : String){
        print("loading image")
        
        lasturlusedtoloadImage = urlString
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch ImageURLs")
                return
            }
            
            if let cachedImage = imageCache[urlString] {
                self.image = cachedImage
                return
            }
            //If the url loaded here is not the same as the imageURL from post, then dont proceed further
            //Once we run the URLSession, it will load the Url in a longer time because it is being run on async
            if url.absoluteString != self.lasturlusedtoloadImage {
                return
            }
            
            
            
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
        
    }
    
    
    
    
    
}

