//
//  CameraVideoViewController.swift
//  PupsterSocial
//
//  Created by Tomoki Takasawa on 7/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//
// Part of the code is acquired from https://github.com/jen2/Speech-Recognition-Demo

import Foundation
import UIKit
import SwiftyCam
import Speech
import SCLAlertView

class CameraVideoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    
    let coverLayer = CALayer()
    let toTextLabel = UILabel()
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let scrollView = UIScrollView()
    let baseView = UIView()
    
    let flipCameraButton : UIButton = {
        let b = SwiftyRecordButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Flip", for: .normal)
        b.setTitleColor(.white, for: .normal)
        
//        b.setImage(#imageLiteral(resourceName: "flipCameraIcon"), for: .normal)
//        b.imageView?.contentMode = .scaleAspectFit
//        b.tintColor = .white
        return b
    }()
    
    
    let exitButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "goBackIcon"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        return b
    }()
    
    let captureButton = SwiftyRecordButton(frame: CGRect(x: 100, y: 100, width: 75, height: 75))
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(captureButton)
        self.view.addSubview(flipCameraButton)
        self.view.addSubview(exitButton)
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        toTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        captureButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        flipCameraButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        flipCameraButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        flipCameraButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        flipCameraButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchTapped), for: .touchUpInside)
        
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        
        captureButton.addTarget(self, action: #selector(self.centerButtonPressed), for: .touchUpInside)
        captureButton.isSelected = false
        captureButton.isUserInteractionEnabled = true
        //captureButton.buttonEnabled = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        
        self.view.addSubview(baseView)
        baseView.addSubview(scrollView)
        
        
        baseView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -130).isActive = true
        baseView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        baseView.heightAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 80.0/329.0).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: baseView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: baseView.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: baseView.rightAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //gradient.frame = baseView.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func centerButtonPressed(){
        if (captureButton.isSelected == false) {
            captureButton.growButton()
            captureButton.isSelected = true
            displayOverlayView()
            
            self.recordAndRecognizeSpeech()
        }else{
            captureButton.shrinkButton()
            captureButton.isSelected = false
            removeLayer()
            
            //request.endAudio()
            audioEngine.stop()
            
            let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
            
            recognitionTask?.cancel()
            
        }
    }
    
    
    func displayOverlayView(){
        
        coverLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        coverLayer.frame = view.layer.bounds
        view.layer.insertSublayer(coverLayer, at: 1)
        
        toTextLabel.text = " "
        
        scrollView.addSubview(toTextLabel)
        
        toTextLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        toTextLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5).isActive = true
        toTextLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        toTextLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        toTextLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        
        
        gradient = CAGradientLayer()
        gradient.frame = baseView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.1, 0.9, 1]
        baseView.layer.mask = gradient
        
        toTextLabel.bringSubview(toFront: toTextLabel)
        toTextLabel.textColor = .white
        toTextLabel.numberOfLines = 0
        
    }
    
    private var gradient: CAGradientLayer!
    
    func removeLayer(){
        self.coverLayer.removeFromSuperlayer()
        toTextLabel.removeFromSuperview()
    }
    
    @objc func exitTapped(){
        if let navigator = self.navigationController {
            navigator.popViewController(animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //captureButton.delegate = self
    }
    
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    @objc func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
}

extension CameraVideoViewController {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "recordButton"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
}


extension CameraVideoViewController {
    //refer to jay2 speech recognition
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.showAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.showAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.showAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            
            print(error.debugDescription)
            
            if result != nil {
                
                if let result = result {
                    let bestString = result.bestTranscription.formattedString
                    DispatchQueue.main.async {
                        self.toTextLabel.text = bestString
                        self.toTextLabel.setNeedsDisplay()
                        //TODO: Scroll to bottom here
                    }
                    
                    
                    var lastString: String = ""
                    for segment in result.bestTranscription.segments {
                        let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                        lastString = bestString.substring(from: indexTo)
                    }
                    //self.checkForColorsSaid(resultString: lastString)
                }else if let error = error {
                    self.showAlert(message: "There has been a speech recognition error.")
                    print(error)
                }
            }else{
//                self.showAlert(message: "There has been a speech recognition error.")
//                print(error)
            }
        })
    }
    
    func showAlert(message: String){
        SCLAlertView().showInfo("INFO", subTitle: message)
    }
    
    func checkAuthorization(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
//            OperationQueue.main.addOperation {
//                switch authStatus {
//                case .authorized:
//                    //self.captureButton.isEnabled = true
//                case .denied:
//                    self.captureButton.isEnabled = false
//                    self.toTextLabel.text = "User denied access to speech recognition"
//                case .restricted:
//                    self.captureButton.isEnabled = false
//                    self.toTextLabel.text = "Speech recognition restricted on this device"
//                case .notDetermined:
//                    self.captureButton.isEnabled = false
//                    self.toTextLabel.text = "Speech recognition not yet authorized"
//                }
//            }
        }
    }
}
