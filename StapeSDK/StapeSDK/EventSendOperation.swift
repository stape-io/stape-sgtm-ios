//
//  EventSendOperation.swift
//  StapeSDK
//
//  Created by Deszip on 17.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class EventSendOperation: Operation {
    var queue: EventQueue?
    
    private var processing: Bool {
        willSet {
            willChangeValue(forKey: "isFinished")
            willChangeValue(forKey: "isExecuting")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    let operationUUID: String
    override var isFinished: Bool { return !processing }
    override var isExecuting: Bool { return processing }
    
    private let config: Stape.Configuration
    private let event: Stape.Event
    
    init(config: Stape.Configuration, event: Stape.Event) {
        self.processing = false
        self.operationUUID = NSUUID().uuidString
        self.config = config
        self.event = event
        
        super.init()
    }
    
    override func start() {
        Stape.logger.info("Starting: \(self)")
        
        if isCancelled { return }
        processing = true
        
        guard let request = self.buildRequest() else {
            self.finish()
            return
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil{
                Stape.logger.info("Response error: \(String(describing: error))")
                return
            }

            do {
                if let data = data {
                    let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                    Stape.logger.info("Result: \(String(describing: result))")

                }
            } catch {
                Stape.logger.info("Response serialization Error -> \(error)")
            }
            
            self.finish()
        })

        task.resume()
    }
    
    override func cancel() {
        Stape.logger.info("Finished: \(self)")

        finish()
    }
    
    func finish() { processing = false }
    
    private func buildRequest() -> URLRequest? {
        guard let url = URL(string: self.config.domain.absoluteString.appending(self.config.endpoint)),
              var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        comps.queryItems = [
            URLQueryItem(name: "v", value: self.config.protocolVersion),
            URLQueryItem(name: "event_name", value: self.event.name),
            URLQueryItem(name: "richsstsse", value: self.config.richsstsse ? "true" : "false")
        ]
        
        guard let fullURL = comps.url else {
            return nil
        }
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.event.payload, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
//            print("Failed to encode payload: \(error)")
            Stape.logger.info("Failed to encode payload: \(error)")

            return nil
        }
        
        return request
    }
}
