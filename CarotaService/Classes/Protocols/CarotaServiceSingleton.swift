//
//  CarotaServiceSingleton.swift
//  CarotaService
//
//  Created by Elias Ferreira on 18/01/23.
//

import Foundation

public protocol ServiceSingleton {
    typealias CSResult<T: Decodable> = (Result<T, CSError>) -> Void
    
    var authorization: HTTPAuthentication? { get set }
    
    func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod,  body: HTTPBody?, completion: @escaping CSResult<T>)
    func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod, body: HTTPBody?) async throws -> T
}

extension ServiceSingleton {
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get,  body: HTTPBody? = nil, completion: @escaping CSResult<T>) {
        request(url: convertible, method: method, body: body, completion: completion)
    }
    
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get, body: HTTPBody? = nil) async throws -> T {
        try await request(url: convertible, method: method, body: body)
    }
}
