//
//  AudioViewController.swift
//  Kaiwa
//
//  Created by Tomoki William Takasawa on 10/7/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class AudioViewController : UIViewController, URLSessionDataDelegate {
    
    var session: URLSession!
    var accumulated = Data()
    let textLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button1)
        button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button1.backgroundColor = .red
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button2.backgroundColor = .blue
        
        button1.addTarget(self, action: #selector(self.startIdentity), for: .touchUpInside)
        button2.addTarget(self, action: #selector(self.startChunked), for: .touchUpInside)
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
    }
    
    
    
    @objc func startIdentity() {
        textLabel.text = "ellod"
    }
    
    @objc func startChunked() {
        DispatchQueue.main.async {
            self.textLabel.text = "hola"
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        let bodyStream = InputStream(data: AudioViewController.testBody)
        completionHandler(bodyStream)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        NSLog("data chunk: %@", data as NSData)
        self.accumulated.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        AudioViewController.print(error: error, response: task.response, body: self.accumulated)
    }
    
    static let testRequest: URLRequest = {
        var result = URLRequest(url: URL(string: "https://us-central1-kaiwa-1fe22.cloudfunctions.net/app")!)
        result.httpMethod = "POST"
        result.setValue("multipart/form-data; boundary=Boundary-0DFADA5A-6C2F-4FD9-9E92-CCBB2A100278", forHTTPHeaderField: "Content-Type")
        return result
    }()
    
    static let testBody: Data = {
        var result = Data()
        
        func add(_ string: String) {
            result.append(string.data(using: String.Encoding.utf8)!)
        }
        
        // empty preamble
        add("\r\n")
        add("--Boundary-0DFADA5A-6C2F-4FD9-9E92-CCBB2A100278\r\n")
        add("Content-Disposition: form-data; name=\"greetings\"\r\n")
        add("Content-Type: text/plain; charset=UTF-8\r\n")
        add("\r\n")
        add("Hello Cruel World!")
        add("\r\n")
        add("--Boundary-0DFADA5A-6C2F-4FD9-9E92-CCBB2A100278\r\n")
        add("Content-Disposition: form-data; name=\"salutations\"\r\n")
        add("Content-Type: text/plain; charset=UTF-8\r\n")
        add("\r\n")
        add("Goodbye Cruel World!")
        add("\r\n")
        add("--Boundary-0DFADA5A-6C2F-4FD9-9E92-CCBB2A100278--\r\n")
        add("\r\n")
        //empty epilogue
        
        return result
    }()
    
    static func print(error: Error?, response: URLResponse?, body: Data?) {
        if let error = error as NSError? {
            NSLog("failed, error: %@ / %d", error.domain, error.code)
        } else {
            let response = response! as! HTTPURLResponse
            let body = body!
            
            NSLog("success, status: %d", response.statusCode)
            
            if let root = try? JSONSerialization.jsonObject(with: body, options: []) {
                NSLog("response: %@", "\(root)")
            } else {
                NSLog("response not parsed")
            }
        }
    }
}
