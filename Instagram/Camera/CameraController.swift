//
//  CameraController.swift
//  InstagramFirebase
//
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    //UIViewControllerTransitionDelegate allows us to transition to the viewController
    
    //Use the AVCapturePhotoCaptureDelegate to use the Camera
    //Use the dismiss button and add a target when its touched
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleDismiss() {
        
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
        transitioningDelegate = self
    }
    
    let customanimationpresenter = CustomAnimationPresenter()
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customanimationpresenter
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Setup anchors for the buttons
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 80, height: 80)
    }
    
    @objc func handleCapturePhoto() {
        print("Capturing photo...")
        
        let settings = AVCapturePhotoSettings()
        
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        //A CMSampleBuffer is a Core Foundation object containing zero or more compressed (or uncompressed) samples of a particular media type (audio, video, muxed, and so on).
        // AVCaptureBracketedStillImageSettings A description of the features and settings in use for an in-progress or complete photo capture request. Photo capture settings
        // imageData contains the outPut in JPEG format with forJpegSampleBuffer to be the photoSampleBuffer, and the previewBuffer to be the previewPhotoSampleBuffer
        
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        
        
        //How does the TakePicture button know which button is pressed? Only when the handlePhoto button is pressed, then the AVCApturing begins. In the capture class, we add the subview and once we run it, it displays the yellow screen
        
        //Preview image will contain the JPEG data captured above
        let previewImage = UIImage(data: imageData!)
        
        
        
        let containerView = PreviewPhotoContainerView()
        //containerView.previewImageView.image = previewImage
        //containerView.previewImageView.image = previewImage
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //ImageView will then contain the image
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        print("Finished processing sample buffer...")
    }
    
    //Output refers to the AVCapturePhotoOutput
    //CaptureSession refers to An object that manages capture activity and coordinates the flow of data from input devices to capture outputs.
    let output = AVCapturePhotoOutput()
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        
        //If an error is thrown by the code in the do clause, it is matched against the catch clauses to determine which one of them can handle the error.
        do {
                        let input = try AVCaptureDeviceInput(device: captureDevice)
                        if captureSession.canAddInput(input) {
                            captureSession.addInput(input)
                        }
                    } catch let err {
                        print("Could not setup camera input:", err)
                    }
        
        
        
        //2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
}

//
