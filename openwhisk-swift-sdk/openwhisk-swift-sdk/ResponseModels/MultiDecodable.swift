//
//  MultiDecodable.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public struct Limits: Codable {
    public var timeout: Double
    public var memory: Double
    public var logs: Double
}

public struct Annotation: Codable {
    public var key: String
    public var value: MultiDecodable
}

public struct InvocationResult: Codable {
    public var success: Bool
    public var status: String
}

public enum MultiDecodable: Codable {
    public func encode(to encoder: Encoder) throws {
        return // THIS 👏 NEEDS 👏 TO 👏 BE 👏 UPDATED 👏
    }
    
    case float(Float), string(String), bool(Bool), limits(Limits)
    
    public init(from decoder: Decoder) throws {
        if let float = try? decoder.singleValueContainer().decode(Float.self) {
            self = .float(float)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }
        
        if let limits = try? decoder.singleValueContainer().decode(Limits.self) {
            self = .limits(limits)
            return
        }
        
        throw MultiDecodableError.missingValue
    }
    
    public enum MultiDecodableError: Swift.Error {
        case missingValue
    }
}
