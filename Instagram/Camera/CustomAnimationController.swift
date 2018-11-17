//
//  CustomAnimationController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-17.
//  Copyright © 2018 Shehryar. All rights reserved.
//

//import Foundation
//import UIKit
//
//class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.5
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        //my custom transition animation code logic
//        
//        let containerView = transitionContext.containerView
//        guard let fromView = transitionContext.view(forKey: .from) else { return }
//        guard let toView = transitionContext.view(forKey: .to) else { return }
//        
//        containerView.addSubview(toView)
//        
//        let startingFrame = CGRect(x: 300, y: 0, width: toView.frame.width, height: toView.frame.height)
//        toView.frame = startingFrame
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            //animation??
//            
//            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
//            
//            fromView.frame = CGRect(x: 300, y: 300, width: 0, height: 0)
//            
//        }) { (_) in
//            transitionContext.completeTransition(true)
//        }
//    }
//    
//}
