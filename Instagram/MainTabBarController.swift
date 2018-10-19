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

class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        
        //Once this viww is loaded, you need to check if the currentUser has been authenticated. If he has not been authenticated, then we push the view's to the LoginController and present that controller.
        //
        
        
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
        
        //The view containing multiple views is a CollectionViewFlowLayout
        //The collectionViewFlow layout allows us to determine where to put what. Header, footer, tabBar
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
    
    //Pods are working now
}
