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

public struct ExecNode: Codable {
    public var kind: String?
    public var code: String?
}

public struct InvocationResult<O: Codable>: Codable {
    public var success: Bool?
    public var status: String?
    public var result: O?
}

public enum MultiDecodable: Codable {
    case float(Float)
    case string(String)
    case bool(Bool)
    case limits(Limits)
    
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
    
    public func encode(to encoder: Encoder) throws {
        return // THIS 👏 NEEDS 👏 TO 👏 BE 👏 UPDATED 👏
    }
    
    public enum MultiDecodableError: Swift.Error {
        case missingValue
    }
}
