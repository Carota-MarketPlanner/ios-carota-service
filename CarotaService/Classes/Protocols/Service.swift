//
//  Service.swift
//  CarotaService
//
//  Created by Elias Ferreira on 18/01/23.
//

import Foundation

public protocol CSCloudService {
    typealias CSResponse = Result<Data, CSError>
    typealias CSDecodedResponse<T> = Result<T, CSError>
    typealias CSCompletion = (CSResponse) -> Void
    typealias CSDecodedCompletion<T: Decodable> = (CSDecodedResponse<T>) -> Void
    
    func request(url convertible: URLConvertible,
                 method: HTTPMethod,
                 body: HTTPBody?,
                 completion: @escaping CSCompletion)
    
    func request<T: Decodable>(url convertible: URLConvertible,
                               method: HTTPMethod,
                               body: HTTPBody?,
                               completion: @escaping CSDecodedCompletion<T>)
    
//    func request(url convertible: URLConvertible,
//                 method: HTTPMethod,
//                 body: HTTPBody?) async throws -> Data
//    
//    func request<T: Decodable>(url convertible: URLConvertible,
//                               method: HTTPMethod,
//                               body: HTTPBody?) async throws -> T
}

extension CSCloudService {
    public func request(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        body: HTTPBody? = nil,
        completion: @escaping CSCompletion
    ) {
        request(
            url: convertible,
            method: method,
            body: body,
            completion: completion
        )
    }
    
    public func request<T: Decodable>(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        body: HTTPBody? = nil,
        completion: @escaping CSDecodedCompletion<T>
    ) {
        request(
            url: convertible,
            method: method,
            body: body,
            completion: completion
        )
    }
    
//    public func request(
//        url convertible: URLConvertible,
//        method: HTTPMethod = .get,
//        body: HTTPBody? = nil
//    ) async throws -> Data {
//        try await request(
//            url: convertible,
//            method: method,
//            body: body
//        )
//    }
//    
//    public func request<T: Decodable>(
//        url convertible: URLConvertible,
//        method: HTTPMethod = .get,
//        body: HTTPBody? = nil
//    ) async throws -> T {
//        try await request(
//            url: convertible,
//            method: method,
//            body: body
//        )
//    }
}
