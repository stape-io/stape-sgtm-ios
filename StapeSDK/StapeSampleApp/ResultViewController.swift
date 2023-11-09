//
//  ResultViewController.swift
//  StapeSampleApp
//
//  Created by Deszip on 15.10.2023.
//  Copyright © 2023 Stape. All rights reserved.
//

import UIKit
import StapeSDK

class ResultViewController: UIViewController {

    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        NotificationCenter.default.addObserver(self, selector: #selector(handleResult), name: NSNotification.Name("EventResultNotification"), object: nil)
        
        Stape.addFBEventHandler({ self.display(result: $0) }, forKey: "ResultViewController")
    }
    
    @objc
    func handleResult(notification: Notification) {
        if let result = notification.userInfo?["result"] as? Stape.EventResult {
            self.display(result: result)
        }
    }
    
    private func display(result: Stape.EventResult) {
        DispatchQueue.main.async {
            var log = ""
            switch result {
            case .success(let response):
                log.append(response.payload.description)
            case .failure(let error):
                log.append(error.localizedDescription)
            }
            self.resultTextView.text = log + "\n" + self.resultTextView.text
        }
    }
    
}
