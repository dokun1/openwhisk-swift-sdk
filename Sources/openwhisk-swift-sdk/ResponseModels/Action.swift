//
//  Action.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public struct Action: Codable {    
    public var name: String
    public var namespace: String
    public var version: String
    public var limits: Limits
    public var publish: Bool
    public var updated: Date
    public var annotations: [Annotation]
}
