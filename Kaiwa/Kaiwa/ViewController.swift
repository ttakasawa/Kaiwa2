//
//  ViewController.swift
//  Kaiwa
//
//  Created by Tomoki Takasawa on 10/6/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.backgroundColor = .red
        
        button.addTarget(self, action: #selector(self.tapped), for: .touchUpInside)
    }

    @objc func tapped() {
        if let navigator = self.navigationController {
            navigator.pushViewController(CameraVideoViewController(), animated: true)
        }
    }

}

