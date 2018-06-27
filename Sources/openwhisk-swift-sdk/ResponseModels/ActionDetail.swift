//
//  ActionDetail.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/27/18.
//

import Foundation

public struct ActionDetail: Codable {
    public var name: String
    public var namespace: String
    public var version: String
    public var limits: Limits
    public var publish: Bool
    public var updated: Date?
    public var annotations: [Annotation]?
    public var exec: ExecNode?
}
