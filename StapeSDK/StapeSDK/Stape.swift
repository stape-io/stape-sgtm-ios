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
    
    public typealias EventResult = Result<Stape.EventResponse, SendError>
    public typealias Completion = (EventResult) -> Void
    
    // Error types
    public enum SendError: Error {
        case networkFailure(Error)
        case serializationFailure
        case noData
    }
    
    // Models
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
        public enum Key: String {
            case clientID       = "client_id"
            // Pls check Apple docs on IDFA:
            // https://developer.apple.com/documentation/apptrackingtransparency?language=objc
            case idfa           = "idfa"
            case currency       = "currency"
            case ipOverride     = "ip_override"
            case language       = "language"
            case pageEncoding   = "page_encoding"
            case pageHostname   = "page_hostname"
            case pageLocation   = "page_location"
            case pagePath       = "page_path"
        }
        
        public let name: String
        public let payload: [String: AnyHashable]
        
        public init(name: String, payload: [String : AnyHashable] = [:]) {
            self.name = name
            self.payload = payload
        }
        
        public init(name: String, payload: [Key : AnyHashable] = [:]) {
            self.name = name
            self.payload = Dictionary(uniqueKeysWithValues: payload.map { ($0.key.rawValue, $0.value) })
        }
    }
    
    public struct EventResponse {
        public let payload: [String: AnyObject]
    }
    
    // SDK State
    private enum State {
        case running(Configuration)
        case idle
        
        func handleStart(_ stape: Stape, configuration: Configuration) -> State {
            stape.apiCLient.config = configuration
            return .running(configuration)
        }
        
        func handleFBHookInstall(stape: Stape) -> State {
            STFirebaseHook.installLogEventHook { name, parameters in
                if let name = name as? String,
                   let payload = parameters as? [String: AnyHashable] {
                    Stape.send(event: Stape.Event(name: name, payload: payload)) { result in
                        stape.fbHandlers.forEach { $0.value(result) }
                    }
                }
            }
            return self
        }
        
        func handleEvent(_ stape: Stape, event: Event, completion: Completion? = nil) -> State {
            if case State.running = self {
                stape.apiCLient.send(event: event, completion: completion)
            }
            
            return self
        }
    }
    
    private static var shared: Stape = { return Stape(apiCLient: APIClient()) }()
    
    static let logger = Logger(subsystem: "com.stape.logger", category: "main")
    private var state: State = .idle
    private let apiCLient: APIClient
    
    private var fbHandlers: [String: Completion] = [:]
    
    init(apiCLient: APIClient) {
        self.state = .idle
        self.apiCLient = apiCLient
    }
    
    // MARK: - Public API
    
    public static func start(configuration: Configuration) {
        shared.start(configuration: configuration)
    }
    
    public static func send(event: Event, completion: Completion? = nil) {
        shared.send(event: event, completion: completion)
    }
    
    public static func startFBTracking() {
        shared.startFBTracking()
    }
    
    public static func addFBEventHandler(_ handler: @escaping Completion, forKey key: String) {
        shared.addFBEventHandler(handler, forKey: key)
    }
    
    public static func removeFBEventHandler(forKey key: String) {
        shared.removeFBEventHandler(forKey: key)
    }
    
    // MARK: - Private API
    
    private func start(configuration: Configuration) {
        state = state.handleStart(self, configuration: configuration)
    }
    
    private func send(event: Event, completion: Completion? = nil) {
        state = state.handleEvent(self, event: event, completion: completion)
    }
    
    private func startFBTracking() {
        state = state.handleFBHookInstall(stape: self)
    }
    
    private func addFBEventHandler(_ handler: @escaping Completion, forKey key: String) {
        fbHandlers[key] = handler
    }
    
    private func removeFBEventHandler(forKey key: String) {
        fbHandlers.removeValue(forKey: key)
    }
    
}
