//
//  StapeTests.swift
//  StapeTests
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import InstantMock
import Nimble
@testable import StapeSDK

final class StapeTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func test() {
        let sut = Stape(apiCLient: APIClient())
    }

}
