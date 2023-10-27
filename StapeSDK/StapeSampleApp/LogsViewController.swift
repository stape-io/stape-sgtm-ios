//
//  LogsViewController.swift
//  StapeSampleApp
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import UIKit
import OSLog
import StapeSDK

class LogsViewController: UIViewController {
    
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            do {
                let logStore = try OSLogStore(scope: .currentProcessIdentifier)
                let pos = logStore.position(date: Date().addingTimeInterval(-3600))
                let entries = try logStore.getEntries(at: pos)
                    .compactMap { $0 as? OSLogEntryLog }
//                    .filter { $0.subsystem == "com.stape.logger" }
                    .map { "[\($0.date.formatted())] [\($0.category)] \($0.composedMessage)" }
                    .reversed()
                    .joined(separator: "\n")

                self.logTextView.text = entries
                
            } catch {
                //...
            }

        }

    }

}
