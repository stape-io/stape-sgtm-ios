//
//  Stape.swift
//  StapeSDK
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

public class Stape {
    public struct Configuration {
        let host: URL
        let endpoint: String
        let richsstsse: Bool
        
        public init(host: URL, endpoint: String = "/data", richsstsse: Bool = false) {
            self.host = host
            self.endpoint = endpoint
            self.richsstsse = richsstsse
        }
    }
    
    private enum State {
        case running(Configuration)
        case idle
    }
    
    public static func version() -> String {
        return "0.1.0"
    }
    
    public static func start(configuration: Configuration) {
        //...
    }
    
}
