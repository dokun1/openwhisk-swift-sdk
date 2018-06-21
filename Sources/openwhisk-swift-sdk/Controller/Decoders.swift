//
//  Decoders.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/21/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

class Decoders {
    internal static func decodeActionResponse(_ data: Data) throws -> [Action] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        do {
            let actions = try decoder.decode([Action].self, from: data)
            return actions
        } catch let error {
            throw error
        }
    }
    
    internal static func decodeInvocationResponse(_ data: Data) throws -> InvocationResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        do {
            let response = try decoder.decode(InvocationResponse.self, from: data)
            return response
        } catch let error {
            throw error
        }
    }
}
