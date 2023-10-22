//
//  Stape.swift
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import Foundation
import os

public class Stape {
    public struct Configuration {
        let domain: URL
        let endpoint: String
        let richsstsse: Bool
        let protocolVersion: String
        
        public init(domain: URL, endpoint: String = "/data", richsstsse: Bool = false, protocolVersion: String = "2") {
            self.domain = domain
            self.endpoint = endpoint
            self.richsstsse = richsstsse
            self.protocolVersion = protocolVersion
        }
    }
    
    public struct Event {
        public let name: String
        public let payload: [AnyHashable: AnyHashable]
        
        public init(name: String, payload: [AnyHashable : AnyHashable] = [:]) {
            self.name = name
            self.payload = payload
        }
    }
    
    private enum State {
        case running(Configuration)
        case idle
        
        func handleStart(configuration: Configuration, stape: Stape) -> State {
            stape.apiCLient.config = configuration
            return .running(configuration)
        }
        
        func handleFBHookInstall(stape: Stape) -> State {
            STFirebaseHook.installLogEventHook { name, parameters in
                if let name = name as? String,
                   let payload = parameters as? [AnyHashable: AnyHashable] {
                    Stape.send(event: Stape.Event(name: name, payload: payload))
                }
            }
            return self
        }
        
        func handleEvent(_ event: Event, stape: Stape) -> State {
            if case State.running = self {
                stape.apiCLient.send(event: event)
            }
            
            return self
        }
    }
    
    static var shared: Stape = { return Stape(apiCLient: APIClient()) }()
    
    static let logger = Logger(subsystem: "com.stape.logger", category: "main")
    private var state: State = .idle
    private let apiCLient: APIClient
    
    init(apiCLient: APIClient) {
        self.state = .idle
        self.apiCLient = apiCLient
    }
    
    // MARK: - Public API
    
    public static func start(configuration: Configuration) {
        shared.start(configuration: configuration)
    }
    
    public func start(configuration: Configuration) {
        state = state.handleStart(configuration: configuration, stape: self)
    }
    
    public static func send(event: Event) {
        shared.send(event: event)
    }
    
    public func send(event: Event) {
        state = state.handleEvent(event, stape: self)
    }
    
    public static func startFBTracking() {
        shared.startFBTracking()
    }
    
    public func startFBTracking() {
        state = state.handleFBHookInstall(stape: self)
    }
    
}
