//
//  ActionsController.swift
//  StapeSampleApp
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import UIKit
import StapeSDK

import FirebaseCore
import FirebaseAnalytics

class ActionsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: self.sendStapeEvent()
        case 1: self.sendFBSelectContentEvent()
        case 2: self.sendFBSelectItemEvent()
        
        default: ()
        }
        
    }

    // MARK: - Actions
    
    private func sendStapeEvent() {
        Stape.send(event: Stape.Event(name: "foo", payload: ["bar": "baz"])) { result in
            
            let notification = Notification(name: Notification.Name( "EventResultNotification"), object: self, userInfo: ["result" : result])
            NotificationCenter.default.post(notification)
            
            switch result {
            case .success(let response): print("Event sent: \(response)")
            case .failure(let error): print("Failed to send event: \(error)")
            }
            
        }
    }
    
    private func sendFBSelectContentEvent() {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "fb-event-AnalyticsEventSelectContent",
          AnalyticsParameterItemName: "FB Event",
          AnalyticsParameterContentType: "sample event"
        ])
    }
    
    private func sendFBSelectItemEvent() {
        Analytics.logEvent(AnalyticsEventSelectItem, parameters: [
          AnalyticsParameterItemID: "fb-event-AnalyticsEventSelectItem",
          AnalyticsParameterItemName: "FB Event",
          AnalyticsParameterContentType: "sample event"
        ])
    }
}
