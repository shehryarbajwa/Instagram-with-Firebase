//
//  CameraController.swift
//  Instagram
//
//  Created by Shehryar Bajwa on 2018-11-14.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import AVFoundation

class Cameracontroller : UIViewController {
    
    let dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let capturePhotoButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupCaptureSession()
        
        setupHUD()
        
    }
    
    fileprivate func setupHUD(){
    capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 80, height: 80)
    capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCapturePhoto(){
        print("Capturing photo")
    }
    
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        //Uses for video and audio capabilities
        //The AVCApture Session, use to coordinate the flow of data from AV input devices to output
        
        //1- Setup inputs
        //Use the AVCaptureSession() function. Then use the AVCaptureDevicve.default(for: .video/photos)
        //Then use a do catch. It is recommended that we wrap any functions that throws (with try) into a do-catch block
        //Video capturing device on the phone
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            
            guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
            captureSession.addInput(input)
        }
        }   catch let err {
            print("Couldnot set up the camera input: \(err)")
        }
        
        //2-Setup Outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        //3-Set up preview
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        print("Successfully showcasing camera")
        captureSession.startRunning()
    }
    
    
    
    
}
