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
        collectionView?.backgroundColor = .white
        setupNavigationButtons()
        
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        //This allows us to create a header in our collectionView
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        
        fetchPhotos()
    }
    
    
    var images = [UIImage]()
    
    //We need to create a PHAsset Array and load the cells again once they have loaded. PHAsset is a representation of an image, video, or Live Photo in the Photos library.
    var assets = [PHAsset]()
    
    
    
    //We can save the PHFetchOptions for reusing the code again and in a privatefile instead of using it within FetchOptions phtos
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    func fetchPhotos(){
        //
        //Fetch photos within iOS Library, import Photos
        //Step1: we declare FetchOptions using PHFetchOptions
        //Step2: We declare a limit of 10 photos to be shown. We can make this as big as the size of the library
        //Step3:Use fetchAssets property and fetch the image with the fetchOptions
        //Step4:Then using enumerateObjects, we will go through the imageLibrary one by one and display the images.
        //Step5: Using the imageManager.default property we would then have to setup the targetsize of the images.
        //Step6: This is when we request these images and fill in contentMode
        //Step7: We need to show large sized aspects of them rather than smaller jpg version so we use options as PHImageRequestOptions(). Then we make sure that they are synchronous since they will be being updated on the mainQueue.
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        //Running this on the background queue will free up more more memory for the mainQueue
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        //append the requested image in the empty assets array
                        self.assets.append(asset)
                    }
                    
                    
                    //This will allow us to set the firstImage to be the header's image. The first time the PhotoManager enumerates through the imageArray, the selectedImage is nil.
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                    //Once the background queue loads up, we need to reload the data for the collectionView
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    
                })
                
            }
        }
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //We set the selectedImage to be the images from the indexPaths items
        self.selectedImage = images[indexPath.item]
        //Reload the data so we can render it to the header. This causes the collection view to discard any currently visible items (including placeholders) and recreate items based on the current state of the data source object
        self.collectionView?.reloadData()
        
        //To move the viewall the way to the top
        
        let indexPath = IndexPath(item: 0 , section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    var selectedImage : UIImage?
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
    
    
    
    //Header here refers to the PhotoSelectorHeader class
    var header : PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
        
        //Header's photoImageView refers to the selectedImage which is the currentImage that the user chose
        header.photoImageView.image = selectedImage
        
        self.header = header
        
        //Here we select the selectedImage. SelectedImage is the image we have clicked on. We set the properties in selectItemat Delegate method
        //Set its index. Then make sure that our assets emptyArray
        //We set the index of the selectedAsset to be same index of the image we have selected
        //Once we do this, we then request the imageAgain using the ImageManager's request Image option
        
        if let selectedimage = selectedImage  {
            if let index = self.images.firstIndex(of: selectedimage) {
               let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image
                }
            }
        }
        
        
        
        
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
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Once we declare a newCollectionCell, we can then use its imageView images to be an array of images and display it on each IndexPath. We conform our collectionView to be the new view that we have created. Then set the images of the collectionView to be images we declared in the array above
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        //By doing this we set the cell's image to be the images we have fetched
        cell.photoImageView.image = images[indexPath.item]
       // cell.backgroundColor = .blue
        
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
        
        //Initialize the class SharePhotoController to be an empty UIViewController. Then push the ViewController to the navigationController.
        let sharePhotoController = SharePhotoController()
        
        //Here we change the value of the property selectedImage and assign it the header's photoImageView's image
        sharePhotoController.selectedImage = header?.photoImageView.image
        let ShareController = navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
        
    }
}
