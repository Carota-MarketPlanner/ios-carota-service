//
//  HTTPAuthentication.swift
//  CarotaService
//
//  Created by Elias Ferreira on 24/01/23.
//

import Foundation

public enum HTTPAuthentication {
    
    case basic(username: String, password: String)
    case bearer(token: String)
    
    public var value: String {
        switch self {
        case .basic(let username, let password):
            let credentials = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
            return "Basic \(credentials)"
        case .bearer(let token):
            return "Bearer \(token)"
        }
    }
    
}
