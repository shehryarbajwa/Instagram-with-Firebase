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
        let input = AVCaptureInput()
        
        
        captureSession.addInput(<#T##input: AVCaptureInput##AVCaptureInput#>)
        
        
        //2-Setup Outputs
        //3-Set up preview
        
        let captureSession = AVCaptureSession()
        
        
        
        
        
    }
    
    
    
    
}
