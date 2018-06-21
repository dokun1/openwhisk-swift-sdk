//
//  ViewController.swift
//  openwhisk-swift-sample-app
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import openwhisk_swift_sdk

struct Currency: Codable {
    var code: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let agent = Agent()
        agent.apiKey = "enter api key here"
        agent.secret = "enter secret here"
        agent.organization = "enter organization here"
        agent.space = "enter space here"
        agent.host = "enter host here"
        agent.getActions { (actions: [Action]?, error: AgentError?) in
            guard let actions = actions else {
                return
            }
            for action in actions where action.name == "fetchForeignBitcoin" {
                agent.invoke(action: action, input: Currency(code: "USD"), blocking: true, resultOnly: false, completion: { response, error in
                    print(response.debugDescription)
                })
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

