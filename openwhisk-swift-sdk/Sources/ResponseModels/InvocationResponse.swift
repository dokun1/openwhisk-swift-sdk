//
//  InvocationResponse.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public struct InvocationResponse: Codable {
    public var activationId: String?
    public var duration: Double?
    public var name: String?
    public var subject: String?
    public var publish: Bool?
    public var annotations: [Annotation]?
    public var version: String?
    public var response: InvocationResult?
    public var end: Date?
    public var start: Date?
    public var namespace: String?
    // need to figure out how to handle responses, as those are *truly* dynamic
}
