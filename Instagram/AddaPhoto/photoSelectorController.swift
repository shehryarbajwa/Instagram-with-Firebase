//
//  photoSelectorController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

class Photoselector : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        
        collectionView?.delegate = self
        super.viewDidLoad()
        collectionView?.backgroundColor = .yellow
        setupNavigationButtons()
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        //This allows us to create a header in our collectionView
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
    }
    //This allows us to use the delegate method that allows us to change the layout of the collectionView to a size of our choice
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //By adding this line, we can make our collectionviewcells more adaptable and of an equal width, height
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    //Providing the size for the header option is mandatory same way providing a size for the collectioncells is
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableCell(withReuseIdentifier: "headerID", for: indexPath)
        
        //Can't create this until you provide a reference size for the header
        header.backgroundColor = .red
        return header
        
    }
    //This allows us to minimize the vertical line spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //This allows us to minimize the horizontal line spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //Number of cells to display
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .blue
        
        return cell
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
