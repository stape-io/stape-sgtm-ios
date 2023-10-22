//
//  EventQueue.swift
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import Foundation

class EventQueue: OperationQueue {
    func addOperation(_ op: EventSendOperation) {
        op.queue = self
        super.addOperation(op)
        
        Stape.logger.info("Added: \(op): \(self.operations.count)")
    }
}
