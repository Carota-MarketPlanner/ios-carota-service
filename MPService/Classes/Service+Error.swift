//
//  ServiceError.swift
//  iOS Concurrency
//
//  Created by Elias Ferreira on 10/01/23.
//

import Foundation

public enum ServiceError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String?)
    case corruptData
    case decodinError(String)
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint url is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API faild to issue a valid response", comment: "")
        case .dataTaskError(let localizedDescription):
            return localizedDescription
        case .corruptData:
            return NSLocalizedString("The data provaided apears to be corrupted", comment: "")
        case .decodinError(let localizedDescription):
            return localizedDescription
        }
    }
}

/*

MARK: Guiding Resources

https://nshipster.com/swift-foundation-error-protocols/
https://www.vadimbulavin.com/the-power-of-namespacing-in-swift/
 
*/
