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
    
    internal static func decodeInvocationResponse<O: Codable>(_ data: Data, responseType: O.Type?) throws -> InvocationResponse<O> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        do {
            let response = try decoder.decode(InvocationResponse<O>.self, from: data)
            return response
        } catch let error {
            throw error
        }
    }
    
    internal static func decodeActionDetailResponse(_ data: Data) throws -> ActionDetail {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ActionDetail.self, from: data)
            return response
        } catch let error {
            throw error
        }
    }
}
