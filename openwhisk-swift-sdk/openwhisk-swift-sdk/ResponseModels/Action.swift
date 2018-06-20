//
//  Action.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public struct Action: Codable {    
    var name: String
    var namespace: String
    var version: String
    var limits: Limits
    var publish: Bool
    var updated: Date
    var annotations: [Annotation]
}
