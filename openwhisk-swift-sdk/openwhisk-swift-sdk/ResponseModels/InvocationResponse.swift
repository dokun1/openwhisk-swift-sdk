//
//  InvocationResponse.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public struct InvocationResponse: Codable {
    var activationId: String?
    var duration: Double?
    var name: String?
    var subject: String?
    var publish: Bool?
    var annotations: [Annotation]?
    var version: String?
    var end: Date?
    var start: Date?
    var namespace: String?
    // need to figure out how to handle responses, as those are *truly* dynamic
}
