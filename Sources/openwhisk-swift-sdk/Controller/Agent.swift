//
//  Agent.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 6/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
import SwiftyRequest

public enum AgentError: Swift.Error {
    case noApiKey
    case noSecret
    case noNamespace
    case noHost
    case invalidCredentials
    case noResponseTypeProvided
    case unknown
    
    fileprivate static func process(_ error: Error) -> AgentError {
        guard let restError = error as? RestError else {
            return AgentError.unknown
        }
        if restError.code == 403 {
            return AgentError.invalidCredentials
        } else {
            return AgentError.unknown
        }
    }
}

public class Agent {
    public init() {
        
    }
    
    public var apiKey: String?
    public var secret: String?
    public var namespace: String?
    public var host: String?
    
    private func checkVars() throws {
        guard let _ = apiKey else {
            throw AgentError.noApiKey
        }
        guard let _ = secret else {
            throw AgentError.noSecret
        }
        guard let _ = namespace else {
            throw AgentError.noNamespace
        }
        guard let _ = host else {
            throw AgentError.noHost
        }
    }
    
    public func getActions(completion: @escaping (_ actions: [Action]?, _ error: AgentError?) -> Void) {
        do {
            try checkVars()
            let request = RestRequest(method: .get, url: "\(host!)/api/v1/namespaces/\(namespace!)/actions", containsSelfSignedCert: false)
            request.credentials = Credentials.basicAuthentication(username: apiKey!, password: secret!)
            request.responseData { (response: RestResponse<Data>) in
                switch response.result {
                case .success(let responseData):
                    do {
                        let actions = try Decoders.decodeActionResponse(responseData)
                        return completion(actions, nil)
                    } catch {
                        return completion(nil, AgentError.unknown)
                    }
                case .failure(let error):
                    return completion(nil, AgentError.process(error))
                }
            }
        } catch let error {
            completion(nil, error as? AgentError)
        }
    }
    
    public func getActionDetail(_ action: Action, completion: @escaping (_ response: ActionDetail?, _ error: AgentError?) -> Void) {
        do {
            try checkVars()
            let request = RestRequest(method: .get, url: "\(host!)/api/v1/namespaces/\(namespace!)/actions/\(action.name)", containsSelfSignedCert: false)
            request.credentials = Credentials.basicAuthentication(username: apiKey!, password: secret!)
            request.responseData { (response: RestResponse<Data>) in
                switch response.result {
                case .success(let responseData):
                    do {
                        let modeledResponse = try Decoders.decodeActionDetailResponse(responseData)
                        return completion(modeledResponse, nil)
                    } catch {
                        return completion(nil, AgentError.unknown)
                    }
                case .failure(let error):
                    return completion(nil, AgentError.process(error))
                }
            }
        } catch let error {
            completion(nil, error as? AgentError)
        }
    }
    
    public func invoke<I: Codable, O: Codable>(action: Action, input: I?, responseType: O.Type?, blocking: Bool = false, resultOnly: Bool = false, completion: @escaping (_ response: InvocationResponse<O>?, _ error: AgentError?) -> Void ) {
        do {
            try checkVars()
            if blocking && responseType == nil {
                return completion(nil, AgentError.noResponseTypeProvided)
            }
            let request = RestRequest(method: .post, url: "\(host!)/api/v1/namespaces/\(action.namespace)/actions/\(action.name)?blocking=\(blocking)&result=\(resultOnly)", containsSelfSignedCert: false)
            request.credentials = Credentials.basicAuthentication(username: apiKey!, password: secret!)
            if let input = input {
                request.messageBody = try JSONEncoder().encode(input)
            }
            request.responseData { (response: RestResponse<Data>) in
                switch response.result {
                case .success(let responseData):
                    do {
                        let modeledResponse = try Decoders.decodeInvocationResponse(responseData, responseType: responseType.self)
                        completion(modeledResponse, nil)
                    } catch {
                        return completion(nil, AgentError.unknown)
                    }
                case .failure(let error):
                    return completion(nil, AgentError.process(error))
                }
            }
        }  catch let error {
            completion(nil, error as? AgentError)
        }
    }
}

