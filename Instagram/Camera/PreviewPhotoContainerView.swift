//
//  PreviewPhotoContainerView.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-16.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PreviewPhotoContainerView : UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    
    //Init frame initializes the view with a frame of CGREct properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 50, height: 50)
        
        
        
        
    }
    
    @objc func handleCancel(){
        self.removeFromSuperview()
    }
    
    @objc func handleSave(){
        print("Saving images")
        
        guard let previewImage = previewImageView.image else {return}
        
        //PhPhotoLibrary is A shared object that manages access and changes to the user’s shared photo library.
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            //creationRequest for Asset Creates a request for adding a new image asset to the Photos library
            //A request to create, delete, change metadata for, or edit the content of a Photos asset, for use in a photo library change block is called PHAssetChangeRequest
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
            
            
            
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to PhotoLibrary :\(err)")
                return
            }
            
            print("Successfully saved the image to the library")
        }
        
    }
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
