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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        setupCaptureSession()
    }
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        //Uses for video and audio capabilities
        //The AVCApture Session, use to coordinate the flow of data from AV input devices to output
        
        //1- Setup inputs
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
        //3-Set up preview
        
        
        
        
        
        
        
    }
    
    
    
    
}
