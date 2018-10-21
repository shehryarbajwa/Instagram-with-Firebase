//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-09.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    //Delegate method to disable selecting a viewController from the TabBarController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //The index loops through all the items in the viewControllers array and returns false if the count is 2 which contains our AddPhotoSelector
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            
            //Create a layout for the collectionViewCell
            //Initialize the class we declared in photoSelectorController
            //Embed the VC in a nav controller and present it
            //A concrete layout object that organizes items into a grid with optional header and footer views for each section.
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = Photoselector(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            
            present(navController, animated: true, completion: nil)
            
            
            
            return false
        }
        print(index)
        
        return true
    }
    
    
    
    
    override func viewDidLoad() {
        
        //Once this viww is loaded, you need to check if the currentUser has been authenticated. If he has not been authenticated, then we push the view's to the LoginController and present that controller.
        //
        
        self.delegate = self
        if Auth.auth().currentUser == nil {
            
           // present(ViewController)
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewController()
    }
        
    func setupViewController(){
        
        //Modify this to add more icons to the TabBarController
        
        //The view containing multiple views is a CollectionViewFlowLayout
        //The collectionViewFlow layout allows us to determine where to put what. Header, footer, tabBar
        //Home Button
        
        
        //What is going on here?
        let homeNavController = templateNavController("home_selected", "home_unselected", rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
      
        
       
        
        //Search
        
        let searchNavController = templateNavController("search_selected", "search_unselected")
        
        //LikeButton
        
        let likeNavController = templateNavController("like_selected", "like_unselected")
        
        //Plus
        
        let plusNavController = templateNavController("plus_unselected", "plus_unselected")
        
        
        
        
        //UserProfile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = UIImage(named: "profile_selected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        //UserProfile
     
        
       
        
        viewControllers = [navController , searchNavController , plusNavController , likeNavController , homeNavController]
        
        //What is this?
        
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            
        }
        
        //viewControllers = [navController, UIViewController()]
    }
    
    fileprivate func templateNavController(_ selectedImagestring: String , _ unselectedImagestring : String, rootViewController : UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: unselectedImagestring)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImagestring)
        return navController
    }
    
    //Pods are working now
}
