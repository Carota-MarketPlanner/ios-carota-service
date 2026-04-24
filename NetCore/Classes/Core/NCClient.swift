//
//  NCClient.swift
//  NetCore
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

final public class NCClient {
    public typealias NCResponse = Result<Data, NCError>
    public typealias NCDecodedResponse<T> = Result<T, NCError>
    public typealias NCCompletion = (NCResponse) -> Void
    public typealias NCDecodedCompletion<T: Decodable> = (NCDecodedResponse<T>) -> Void
    
    private var authorization: HTTPAuthentication?
    
    public static let shared = NCClient()
    
    private init() {}
    
    // MARK: - Using Completion
    
    private func result(data: Data?, response: URLResponse?, error: Swift.Error?) -> NCResponse {
        if let statusCodeError = getStatusCodeError(response) {
            return .failure(statusCodeError)
        }
        
        if let err = error {
            return .failure(.dataTaskError(err.localizedDescription))
        }
        
        guard let data = data else {
            return .failure(.corruptData)
        }
        
        return .success(data)
    }
    
    private func decode<T: Decodable>(response: NCResponse) -> NCDecodedResponse<T> {
        switch response {
        case .success(let data):
            do {
                return .success(try JSONDecoder().decode(T.self, from: data))
            } catch {
                return .failure(.decodingError(error.localizedDescription))
            }
        
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - Using Concurrency
    
    private func result(request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
        
            if let statusCodeError = getStatusCodeError(response) {
                throw statusCodeError
            }
            
            return data
        } catch {
            throw NCError.dataTaskError(error.localizedDescription)
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NCError.decodingError(error.localizedDescription)
        }
    }
    
    // MARK: - Prepare Request
    
    private func getRequest(for url: URL, and method: HTTPMethod, body: HTTPBody?) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            guard let data = body.data else { return nil }
            
            request.httpBody = data
            request.addValue(body.contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        if let auth = self.authorization {
            request.addValue(auth.value, forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }
        
        return request
    }
    
    // MARK: - Status Code
    
    private func getStatusCodeError(_ response: URLResponse?) -> NCError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponseStatus
        }
        
        switch httpResponse.statusCode {
        case 401:
            return .unauthorized
        case 404:
            return .notFound
        case 500:
            return .serverError
        case 400:
            return .requestError
        case 200, 201:
            return nil
        default:
            return .unknown
        }
    }
    
}

// MARK: - Auth

extension NCClient {
    /// Method to set an authorization to use in requests
    ///
    /// - auth: `HTTPAuthentication`, can be `basic` or `bearer`
    ///
    /// - Returns: `Void`
    public func setAuthorization(_ auth: HTTPAuthentication) {
        self.authorization = auth
    }
    
    /// Method to clear the authorization previously setted.
    ///
    /// - Returns: `Void`
    public func clearAuthorization() {
        self.authorization = nil
    }
}

// MARK: - Network

extension NCClient {
    
    /// Request method using completion handler: `(Result<Data, NCError>) -> Void`
    ///
    /// - url: `URLConvertible`, `String` and` URL` implements it.
    ///
    /// - Returns: `Void`.
    public func request(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        body: HTTPBody? = nil,
        completion: @escaping NCCompletion
    ) {
        guard let url = convertible.asURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let request = getRequest(for: url, and: method, body: body) else {
            completion(.failure(.encodingError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(self.result(data: data, response: response, error: error))
        }.resume()
    }
    
    /// Request method using completion handler: `(Result<T: Decodable, NCError>) -> Void`
    ///
    /// - url: `URLConvertible`, `String` and` URL` implements it.
    ///
    /// - Returns: `Void`.
    public func request<T: Decodable>(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        body: HTTPBody? = nil,
        completion: @escaping NCDecodedCompletion<T>
    ) {
        request(url: convertible, method: method, body: body) { response in
            completion(self.decode(response: response))
        }
    }
    
    /// Request method using `Concurrency` for `Data`
    ///
    /// - url: `URLConvertible`, `String` and` URL` implements it.
    ///
    /// - Returns: `Data`.
    /// - Throws: `NCError`
    public func request(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        body: HTTPBody? = nil
    ) async throws -> Data {
        guard let url = convertible.asURL() else {
            throw NCError.invalidURL
        }
        
        guard let request = getRequest(for: url, and: method, body: body) else {
            throw NCError.encodingError
        }
        
        return try await result(request: request)
    }
    
    /// Request method using `Concurrency` for `Decodable`.
    ///
    /// - url: `URLConvertible`, `String` and` URL` implements it.
    ///
    /// - Returns: `T: Decodable`.
    /// - Throws: `NCError`
    public func request<T: Decodable>(
        url convertible: URLConvertible,
        method: HTTPMethod = .get,
        body: HTTPBody? = nil
    ) async throws -> T {
        let data = try await request(url: convertible, method: method, body: body)
        return try decode(data: data)
    }
}
