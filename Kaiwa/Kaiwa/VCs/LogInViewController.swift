//
//  LogInViewController.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton
import SCLAlertView

class LoginViewController: UIViewController, Stylables {
    
    let appName = UILabel()
    let button = TransitionButton()
    let baseView = UIView()
    let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "wallpaper"))
    let emailField = InputTextField(type: .email)
    let passwrdField = InputTextField(type: .password)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: #selector(self.tapped), for: .touchUpInside)
        emailField.addTarget(self, action: #selector(self.showAlert), for: .touchUpInside)
        passwrdField.addTarget(self, action: #selector(self.showAlert), for: .touchUpInside)
        
        self.configure()
        self.constrain()
    }
    func configure() {
        
        appName.text = "Kaiwa"
        appName.translatesAutoresizingMaskIntoConstraints = false
        appName.font = self.getBoldFont()
        appName.textColor = self.getSecondaryColor()
        appName.numberOfLines = 1
        appName.adjustsFontSizeToFitWidth = true
        appName.textAlignment = .center
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = self.getMainColor()
        button.layer.cornerRadius = self.getButtonCornerRadius()
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = self.getMediumFont()
        button.setTitleColor(self.getWhiteColor(), for: .normal)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.isUserInteractionEnabled = true
        
        baseView.backgroundColor = self.getOverlayColor()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.isUserInteractionEnabled = true
        
        passwrdField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func constrain(){
        self.view.addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        backgroundImage.addSubview(baseView)
        baseView.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        baseView.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor).isActive = true
        baseView.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor).isActive = true
        baseView.topAnchor.constraint(equalTo: backgroundImage.topAnchor).isActive = true
        
        
        
        baseView.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:-60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 280).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        baseView.addSubview(passwrdField)
        passwrdField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -60).isActive = true
        passwrdField.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        passwrdField.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 30).isActive = true
        
        baseView.addSubview(emailField)
        emailField.bottomAnchor.constraint(equalTo: passwrdField.topAnchor, constant: -20).isActive = true
        emailField.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        emailField.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 30).isActive = true
        
        
        baseView.addSubview(appName)
        appName.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 100).isActive = true
        appName.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        appName.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: 30).isActive = true
        
        button.bringSubview(toFront: button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        button.layer.cornerRadius = self.getButtonCornerRadius()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func tapped(_ button: TransitionButton) {
        button.startAnimation()
        let nextVC = CameraVideoViewController()
        //let nextVC = AudioViewController()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async {
            sleep(1)
            DispatchQueue.main.async(execute: {
                () -> Void in
                
                button.stopAnimation(animationStyle: .expand, completion: {
                    button.layer.cornerRadius = self.getButtonCornerRadius()
                    if let navigator = self.navigationController {
                        navigator.pushViewController(nextVC, animated: false)
                    }
                })
            })
        }
        
        
    }
    
    @objc func showAlert(){
        SCLAlertView().showInfo("Just tap Log In!", subTitle: "It does not have firebase fully integrated. Just press log in!")
    }
}
