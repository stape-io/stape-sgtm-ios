//
//  APIClient.swift
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import Foundation

class APIClient {
    
    private let queue: OperationQueue
    private var eventBuffer: [Stape.Event]
    
    var config: Stape.Configuration? { didSet { self.flush() } }
    
    init() {
        self.queue = OperationQueue()
        self.eventBuffer = []
    }
    
    public func send(event: Stape.Event) {
        if let config = self.config {
            let op = EventSendOperation(config: config, event: event)
            self.queue.addOperation(op)
        } else {
            self.eventBuffer.append(event)
        }
    }
    
    private func flush() {
        self.eventBuffer.forEach { self.send(event: $0) }
    }
    
}
