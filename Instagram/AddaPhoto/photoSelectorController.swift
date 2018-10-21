//
//  photoSelectorController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-10-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit
import Photos

class Photoselector : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let headerID = "headerID"
    override func viewDidLoad() {
        
        collectionView?.delegate = self
        super.viewDidLoad()
        collectionView?.backgroundColor = .yellow
        setupNavigationButtons()
        
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        //This allows us to create a header in our collectionView
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        
        fetchPhotos()
    }
    
    
    var images = [UIImage]()
    
    func fetchPhotos(){
        print("Fetcing")
        //Fetch photos within iOS Library
        //Step1: we declare FetchOptions using PHFetchOptions
        //Step2: We declare a limit of 10 photos to be shown. We can make this as big as the size of the library
        //Step3:Use fetchAssets property and fetch the image with the fetchOptions
        //Step4:Then using enumerateObjects, we will go through the imageLibrary one by one and display the images.
        //Step5: Using the imageManager.default property we would then have to setup the targetsize of the images.
        //Step6: This is when we request these images and fill in contentMode
        //Step7: We need to show large sized aspects of them rather than smaller jpg version so we use options as PHImageRequestOptions(). Then we make sure that they are synchronous since they will be being updated on the mainQueue.
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        allPhotos.enumerateObjects { (asset, count, stop) in
            print(asset)
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in
                print(image)
                if let image = image {
                    self.images.append(image)
                }
                
            })
            
        }
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
    //Return a line inset between header and the rest of the collectionCells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        
        //Can't create this until you provide a reference size for the header
        header.backgroundColor = .yellow
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
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
