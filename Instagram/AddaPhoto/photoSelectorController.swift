//
//  photoSelectorController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class Photoselector : UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .yellow
        setupNavigationButtons()
    }
    
    fileprivate func setupNavigationButtons(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handlenext))
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handlenext(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
        
    }
}
