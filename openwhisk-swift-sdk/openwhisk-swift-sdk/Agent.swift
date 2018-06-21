//
//  Agent.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

public enum AgentError: Swift.Error {
    case noApiKey
    case noSecret
    case noOrganization
    case noSpace
    case noHost
    case invalidCredentials
    case unknown
}

public class Agent {
    public init() {
        
    }
    
    public var apiKey: String?
    public var secret: String?
    public var organization: String?
    public var space: String?
    public var host: String?
    
    private func checkVars() throws {
        guard let _ = apiKey else {
            throw AgentError.noApiKey
        }
        guard let _ = secret else {
            throw AgentError.noSecret
        }
        guard let _ = organization else {
            throw AgentError.noOrganization
        }
        guard let _ = space else {
            throw AgentError.noSpace
        }
        guard let _ = host else {
            throw AgentError.noHost
        }
    }
    
    public func getActions(completion: @escaping (_ actions: [Action]?, _ error: AgentError?) -> Void) {
        do {
            try checkVars()
            let request = RestRequest(method: .get, url: "\(host!)/api/v1/namespaces/\(organization!)_\(space!)/actions", containsSelfSignedCert: false)
            request.credentials = Credentials.basicAuthentication(username: apiKey!, password: secret!)
            request.responseObject { (response: RestResponse<[Action]>) in
                switch response.result {
                case .success(let actions):
                    completion(actions, nil)
                case .failure(let error):
                    guard let restError = error as? RestError else {
                        return completion(nil, AgentError.unknown)
                    }
                    if restError.code == 403 {
                        return completion(nil, AgentError.invalidCredentials)
                    } else {
                        return completion(nil, AgentError.unknown)
                    }
                }
            }
        } catch let error {
            completion(nil, error as? AgentError)
        }
    }
    
    public func invoke<T: Codable>(action: Action, input: T?, blocking: Bool = false, resultOnly: Bool = false, completion: @escaping (_ response: InvocationResponse?, _ error: AgentError?) -> Void ) {
        do {
            try checkVars()
            let request = RestRequest(method: .post, url: "\(host!)/api/v1/namespaces/\(action.namespace)/actions/\(action.name)?blocking=\(blocking)&result=\(resultOnly)", containsSelfSignedCert: false)
            request.credentials = Credentials.basicAuthentication(username: apiKey!, password: secret!)
            if let input = input {
                request.messageBody = try? JSONEncoder().encode(input)
            }
            request.responseObject { (response: RestResponse<InvocationResponse>) in
                switch response.result {
                case .success(let invocationResponse):
                    completion(invocationResponse, nil)
                case .failure(let error):
                    guard let restError = error as? RestError else {
                        return completion(nil, AgentError.unknown)
                    }
                    if restError.code == 403 {
                        return completion(nil, AgentError.invalidCredentials)
                    } else {
                        return completion(nil, AgentError.unknown)
                    }
                }
            }
        }  catch let error {
            completion(nil, error as? AgentError)
        }
    }
}
