//
//  HomeViewController.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var usingSimulator: Bool = true
    var captureSession : AVCaptureSession!
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var currentDevice : AVCaptureDevice!
    var captureDeviceInputBack:AVCaptureDeviceInput!
    var captureDeviceInputFront:AVCaptureDeviceInput!
    var stillImageOutput:AVCapturePhotoOutput!
    var cameraFacingback: Bool = true
    var ImageCaptured: UIImage!
    var cameraState:Bool = true
    var flashOn:Bool = false
    
    let takePhotoButton: UIButton = {
        let t = UIButton()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = UIColor.red
        return t
    }()
    let flipCamera: UIButton = {
        let t = UIButton()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = UIColor.blue
        return t
    }()
    let toggleFlash: UIButton = {
        let t = UIButton()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = UIColor.yellow
        return t
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        loadCamera()
        
        self.view.addSubview(takePhotoButton)
        self.view.addSubview(flipCamera)
        self.view.addSubview(toggleFlash)
        
        takePhotoButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        takePhotoButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        flipCamera.topAnchor.constraint(equalTo: self.takePhotoButton.bottomAnchor, constant: 40).isActive = true
        flipCamera.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        flipCamera.widthAnchor.constraint(equalToConstant: 50).isActive = true
        flipCamera.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        toggleFlash.topAnchor.constraint(equalTo: self.flipCamera.bottomAnchor, constant: 40).isActive = true
        toggleFlash.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        toggleFlash.widthAnchor.constraint(equalToConstant: 50).isActive = true
        toggleFlash.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        takePhotoButton.addTarget(self, action: #selector(self.Takepicture), for: .touchUpInside)
        flipCamera.addTarget(self, action: #selector(self.Flip_Camera), for: .touchUpInside)
        toggleFlash.addTarget(self, action: #selector(self.ChangeFlash), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let settings = AVCapturePhotoSettings()
    func loadCamera() {
        captureSession = AVCaptureSession()
        captureSession.startRunning()
        
        if captureSession.canSetSessionPreset(AVCaptureSession.Preset.high){
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
        }
        
        
        //        let devices = AVCaptureDevice.devices()
        //        //let d = AVCaptureDevice.device
        //
        //        for device in devices! {
        //            if (device as AnyObject).hasMediaType(AVMediaTypeVideo){
        //                if (device as AnyObject).position == AVCaptureDevicePosition.back {
        //                    backCamera = device as! AVCaptureDevice
        //                }
        //                else if (device as AnyObject).position == AVCaptureDevicePosition.front{
        //                    frontCamera = device as! AVCaptureDevice
        //                }
        //            }
        //        }
        
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        //AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified)
        
        if backCamera == nil {
            print("The device doesn't have camera")
        }
        
        currentDevice = backCamera
        configureFlash()
        //var error:NSError?
        
        //create a capture device input object from the back and front camera
        do {
            captureDeviceInputBack = try AVCaptureDeviceInput(device: backCamera)
        }
        catch
        {
            
        }
        do {
            captureDeviceInputFront = try AVCaptureDeviceInput(device: frontCamera)
        }catch{
            
        }
        
        if captureSession.canAddInput(captureDeviceInputBack){
            captureSession.addInput(captureDeviceInputBack)
        } else {
            print("can't add input")
        }
        stillImageOutput = AVCapturePhotoOutput()
        //stillImageOutput.preparedPhotoSettingsArray = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        //stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        settings.livePhotoVideoCodecType = .jpeg
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        if (captureSession?.canAddOutput(stillImageOutput))!{
            captureSession.addOutput(stillImageOutput)
        }
        
        let capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        capturePreviewLayer.frame = self.view.frame
        
        capturePreviewLayer.bounds = self.view.bounds
        
        previewView.layer.addSublayer(capturePreviewLayer)
        
    }
    var previewView: UIView!
    let TakePicButton = UIButton()
    var Flash: UIButton!
    var FlipCamera: UIButton!
    /**
     The method to realize the shutter function.
     */
    @objc func Takepicture(_ sender: UIButton) {
        TakePicButton.isEnabled = true;
        cameraState = false
        if !captureSession.isRunning {
            return
        }
        
        stillImageOutput.capturePhoto(with: self.settings, delegate: self)
        
        //        if let videoConnection = stillImageOutput!.connection(with: AVMediaType.video){
        //
        //            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer,error) -> Void in
        //                if sampleBuffer != nil {
        //                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
        //                    let dataProvider = CGDataProvider(data: imageData as! CFData)
        //                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        //                    self.ImageCaptured = UIImage(cgImage:cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
        //                    //self.captureSession.stopRunning()
        //                    self.performSegue(withIdentifier: "test", sender: self)}
        //            })
        //        }
    }
    
    /**
     The method to realise opening and closing camera flash.
     */
    @objc func ChangeFlash(_ sender: UIButton){
        flashOn = !flashOn
        if flashOn {
            self.Flash.setImage(UIImage(named: "Flash_on"), for: UIControlState.normal)
        }
        else {
            self.Flash.setImage(UIImage(named: "Flash_off"), for: UIControlState.normal)
        }
        self.configureFlash()
    }
    
    /**
     The method to realize changing the camera direction.
     */
    @objc func Flip_Camera(_ sender: UIButton){
        
        cameraFacingback = !cameraFacingback
        if cameraFacingback {
            displayBackCamera()
            self.FlipCamera.setImage(UIImage(named:"Camera flip"), for: UIControlState.normal)
            
        } else {
            
            self.FlipCamera.setImage(UIImage(named:"Camera_flip_self"), for: UIControlState.normal)
            displayFrontCamera()
        }
    }
    
    /**
     The method to load back camera.
     */
    func displayBackCamera(){
        if captureSession.canAddInput(captureDeviceInputBack) {
            captureSession.addInput(captureDeviceInputBack)
        } else {
            captureSession.removeInput(captureDeviceInputFront)
            if captureSession.canAddInput(captureDeviceInputBack) {
                captureSession.addInput(captureDeviceInputBack)
            }
        }
        
    }
    
    /**
     The method to load front camera.
     */
    func displayFrontCamera(){
        if captureSession.canAddInput(captureDeviceInputFront) {
            captureSession.addInput(captureDeviceInputFront)
        } else {
            captureSession.removeInput(captureDeviceInputBack)
            if captureSession.canAddInput(captureDeviceInputFront) {
                captureSession.addInput(captureDeviceInputFront)
            }
        }
    }
    
    /**
     The method to configure flash light.
     */
    func configureFlash(){
        do {
            try backCamera.lockForConfiguration()
        } catch {
            
        }
        if backCamera.hasFlash {
            if flashOn {
                if backCamera.hasTorch {
                    backCamera.torchMode = .on
                }
            }else {
                //                if backCamera.isFlashModeSupported(AVCaptureDevice.FlashMode.off){
                //                    backCamera.flashMode = AVCaptureDevice.FlashMode.off
                //                    //flashOn = false
                //                }
                if backCamera.hasTorch {
                    backCamera.torchMode = .off
                }
            }
        }
        backCamera.unlockForConfiguration()
    }
    
    /**
     The method to realise camera focusing.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchpoint = touches.first
        //        var screenSize = previewView.bounds.size
        //        let location = touchpoint?.location(in: self.view)
        let x = (touchpoint?.location(in: self.view).x)! / self.view.bounds.width
        let y = (touchpoint?.location(in: self.view).y)! / self.view.bounds.height
        
        //        var locationX = location?.x
        //        var locationY = location?.y
        
        focusOnPoint(x: x, y: y)
    }
    
    /**
     The algorithm to reasise autofocus .
     */
    func focusOnPoint(x: CGFloat, y:CGFloat){
        let focusPoint = CGPoint(x: x, y: y)
        if cameraFacingback {
            currentDevice = backCamera
        }
        else {
            currentDevice = frontCamera
        }
        do {
            try currentDevice.lockForConfiguration()
        }catch {
            
        }
        
        if currentDevice.isFocusPointOfInterestSupported{
            
            currentDevice.focusPointOfInterest = focusPoint
        }
        if currentDevice.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus)
        {
            currentDevice.focusMode = AVCaptureDevice.FocusMode.autoFocus
        }
        if currentDevice.isExposurePointOfInterestSupported
        {
            currentDevice.exposurePointOfInterest = focusPoint
        }
        if currentDevice.isExposureModeSupported(AVCaptureDevice.ExposureMode.autoExpose) {
            currentDevice.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
        }
        currentDevice.unlockForConfiguration()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

