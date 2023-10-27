//
//  ResultViewController.swift
//  StapeSampleApp
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        NotificationCenter.default.addObserver(self, selector: #selector(handleResult), name: NSNotification.Name("EventResultNotification"), object: nil)
    }
    
    @objc
    func handleResult(notification: Notification) {
        DispatchQueue.main.async {
            self.resultTextView.text = String(describing: notification.userInfo) + "\n" + self.resultTextView.text
        }
    }
    
}
