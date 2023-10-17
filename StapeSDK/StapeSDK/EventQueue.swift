//
//  EventQueue.swift
//  StapeSDK
//
//  Created by Deszip on 17.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class EventQueue: OperationQueue {
    func addOperation(_ op: EventSendOperation) {
        op.queue = self
        super.addOperation(op)
        
        print("Added: \(op): \(operations.count)")
    }
}
