//
//  CustomImageViewSubclass.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-29.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class CustomImageView : UIImageView {
    
    func loadImage(url : String){
        print("loading image")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch ImageURLs")
                return
            }
            //If the url loaded here is not the same as the imageURL from post, then dont proceed further
            //Once we run the URLSession, it will load the Url in a longer time because it is being run on async
            if url.absoluteString != self.post?.imageUrl {
                return
            }
            
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.photoImageView.image = photoImage
            }
            
            }.resume()
        
    }
    
    
    
    
    
}

