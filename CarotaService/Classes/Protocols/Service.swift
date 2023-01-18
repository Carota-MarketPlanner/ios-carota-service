//
//  Service.swift
//  CarotaService
//
//  Created by Elias Ferreira on 18/01/23.
//

import Foundation

public protocol Service {
    typealias CSResult<T: Decodable> = (Result<T, CSError>) -> Void
    
    func request<T: Decodable>(_ endpoint: String, method: HTTPMethod, body: HTTPBody?, completion: @escaping CSResult<T>)
    func request<T: Decodable>(_ endpoint: String, method: HTTPMethod, body: HTTPBody?) async throws -> T
}

extension Service {
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: HTTPBody? = nil, completion: @escaping CSResult<T>) {
        request(endpoint, method: method, body: body, completion: completion)
    }
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: HTTPBody? = nil) async throws -> T {
        try await request(endpoint, method: method, body: body)
    }
}
