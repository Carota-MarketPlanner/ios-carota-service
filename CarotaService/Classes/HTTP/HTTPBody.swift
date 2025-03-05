//
//  HTTPBody.swift
//  MPService
//
//  Created by Elias Ferreira on 13/01/23.
//

import Foundation

public enum HTTPBody {
    case json(object: Encodable)
    case formData
}

extension HTTPBody {
    var contentType: String {
        switch self {
        case .json(_):
            return "application/json"
            
        case .formData:
            return "multipart/form-data"
        }
    }
}

extension HTTPBody {
    var data: Data? {
        switch self {
        case .json(let object):
            do {
                return try JSONEncoder().encode(object)
            } catch {
                return nil
            }
            
        case .formData:
            // Future implementation of form data
            return Data()
        }
    }
}
