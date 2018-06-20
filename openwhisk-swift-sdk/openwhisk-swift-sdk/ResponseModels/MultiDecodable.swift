//
//  MultiDecodable.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public struct Limits: Codable {
    var timeout: Double
    var memory: Double
    var logs: Double
}

public struct Annotation: Codable {
    var key: String
    var value: MultiDecodable
}

enum MultiDecodable: Codable {
    func encode(to encoder: Encoder) throws {
        return // THIS 👏 NEEDS 👏 TO 👏 BE 👏 UPDATED 👏
    }
    
    case float(Float), string(String), bool(Bool)
    
    init(from decoder: Decoder) throws {
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
        
        throw MultiDecodableError.missingValue
    }
    
    enum MultiDecodableError: Swift.Error {
        case missingValue
    }
}
