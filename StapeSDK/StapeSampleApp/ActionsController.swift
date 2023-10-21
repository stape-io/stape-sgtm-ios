//
//  ActionsController.swift
//  StapeSampleApp
//
//  Created by Deszip on 21.10.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import StapeSDK

class ActionsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        Stape.send(event: Stape.Event(name: "foo", payload: ["bar": "baz"]))
    }

    
}
