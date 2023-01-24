//
//  ServiceError.swift
//  iOS Concurrency
//
//  Created by Elias Ferreira on 10/01/23.
//

import Foundation

public enum CSError: Error {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String?)
    case corruptData
    case decodingError(String)
    case encodingError
    case unauthorized
    case notFound
    case serverError
    case requestError
    case unknown
}

extension CSError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The url is invalid", comment: "")
        case .encodingError:
            return NSLocalizedString("The encoder could not encode object", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API faild to issue a valid response", comment: "")
        case .dataTaskError(let localizedDescription):
            return localizedDescription
        case .corruptData:
            return NSLocalizedString("The data provaided apears to be corrupted", comment: "")
        case .decodingError(let localizedDescription):
            return localizedDescription
        case .unauthorized:
            return NSLocalizedString("Unauthorized", comment: "")
        case .notFound:
            return NSLocalizedString("End point not found", comment: "")
        case .serverError:
            return NSLocalizedString("Server Error", comment: "")
        case .requestError:
            return NSLocalizedString("Request Error", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
        }
    }
}
