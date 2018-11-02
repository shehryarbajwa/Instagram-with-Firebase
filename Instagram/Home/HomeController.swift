//
//  HomeController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-02.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class HomeController : UICollectionViewController {
    
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .red
        //For creating custom cells in the homenewsfeed which will contain the posts
        //We create a collectionViewController which then contains collectionViewCells to display different things. Good design pattern
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .yellow
        
        return cell
    }
}

