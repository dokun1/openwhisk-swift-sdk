//
//  ViewController.swift
//  openwhisk-swift-sample-app
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import openwhisk_swift_sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let agent = Agent()
        agent.apiKey = "enter openwhisk API key here"
        agent.secret = "enter openwhisk secret here"
        agent.organization = "enter ibm cloud organization here"
        agent.space = "enter ibm cloud space here"
        agent.getActions { (actions: [Action]?, error: AgentError?) in
            guard let action = actions?.first else {
                return
            }
            agent.invoke(action: action, blocking: true, completion: { response, error in
                print(response.debugDescription)
            })
            agent.invoke(action: action, completion: { response, error in
                print(response.debugDescription)
            })
        }
    }
}
