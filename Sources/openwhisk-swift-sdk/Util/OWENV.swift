//
//  OWENV.swift
//  openwhisk-swift-sdk
//
//  Created by David Okun IBM on 11/22/18.
//

import Foundation

private struct OWAgent: Codable {
    var agent: OWCredentials?
}

public struct OWCredentials: Codable {
    var apiKey: String?
    var secret: String?
    var namespace: String?
    var host: String?
}

public class OWENV {
    static func fetchCredentials() -> OWCredentials? {
        let envPath = URL(fileURLWithPath: getRootPath())
        do {
            let data = try Data(contentsOf: envPath)
            let creds = try JSONDecoder().decode(OWAgent.self, from: data)
            return creds.agent
        } catch {
            return nil
        }
    }
    
    private static func getRootPath() -> String {
        let utilFilePath = #file
        var rootPath = ""
        let pathComponents = utilFilePath.components(separatedBy: "/")
        for component in 1..<pathComponents.count - 4 {
            rootPath.append("/")
            rootPath.append(pathComponents[component])
        }
        rootPath.append("/.env")
        return rootPath
    }
}
