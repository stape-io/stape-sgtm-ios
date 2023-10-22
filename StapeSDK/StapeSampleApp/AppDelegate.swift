//
//  AppDelegate.swift
//  StapeSampleApp
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import StapeSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        if let url = URL(string: "https://gtm.stape.dog") {
            let c = Stape.Configuration(domain: url)
            Stape.start(configuration: c)
            Stape.startFBTracking()
        }
        
        Stape.send(event: Stape.Event(name: "foo", payload: ["bar": "baz"]))
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        //...
    }


}

