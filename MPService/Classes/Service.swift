//
//  Service.swift
//  MPService
//
//  Created by Elias Ferreira on 10/01/23.
//

import Foundation

protocol Service {
    /// The base URL to the API.
    var baseURL: String { get }
    
    /// Get function using async and await.
    func request<T: Decodable>(_ endpoint: String,
                           method: HTTPMethod,
                           dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
                           keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) async throws -> T
    
    /// Get function using clousure.
    func request<T: Decodable>(_ endpoint: String,
                           method: HTTPMethod,
                           dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
                           keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy,
                           completion: @escaping (Result<T, ServiceError>) -> Void)
}
