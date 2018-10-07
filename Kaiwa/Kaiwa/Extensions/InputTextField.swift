//
//  InputTextField.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

enum InputFieldType {
    case email
    case password
}

class InputTextField: UIButton, Stylables {
    
    let fakeEmailLabel = UILabel()
    let underlineView = UIView()
    let icon = UIImageView()
    
    
    init(type: InputFieldType) {
        super.init(frame: CGRect.zero)
        
        configure(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: InputFieldType){
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        fakeEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        underlineView.backgroundColor = self.getSecondaryColor()
        fakeEmailLabel.textColor = self.getSecondaryColor()
        icon.contentMode = .scaleAspectFit
        
        icon.image = type == .email ? #imageLiteral(resourceName: "emailIcon") : #imageLiteral(resourceName: "passwordIcon")
        
        fakeEmailLabel.font = self.getMediumFont()
        fakeEmailLabel.textColor = self.getSecondaryColor()
        
        fakeEmailLabel.text = type == .email ? "Enter email" : "Enter Password"
        
        
        self.addSubview(icon)
        self.addSubview(fakeEmailLabel)
        self.addSubview(underlineView)
        
        underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        underlineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        icon.bottomAnchor.constraint(equalTo: underlineView.topAnchor, constant: -3).isActive = true
        icon.leftAnchor.constraint(equalTo: underlineView.leftAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        fakeEmailLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 20).isActive = true
        fakeEmailLabel.bottomAnchor.constraint(equalTo: underlineView.topAnchor, constant: -3).isActive = true
        
        fakeEmailLabel.numberOfLines = 1
        
        self.topAnchor.constraint(equalTo: icon.topAnchor, constant: -3)
        
    }
}
