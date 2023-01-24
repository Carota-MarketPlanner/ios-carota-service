//
//  MPService.swift
//  MPService
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

public class CarotaService {
    
    public typealias Output<T> = Result<T, CSError>
    public typealias Handler<T> = (Output<T>) -> Void
    
    var baseURL: URLConvertible?
    public var authorization: HTTPAuthentication?
    
    public static let shared = CarotaService() as ServiceSingleton
    
    private init(baseURL: URLConvertible? = nil) {
        self.baseURL = baseURL
    }
    
    public static func getInstance(for baseURL: URLConvertible) -> Service {
        return CarotaService(baseURL: baseURL) as Service
    }
        
    private func result<T: Decodable>(data: Data?, response: URLResponse?, error: Swift.Error?) -> Output<T> {
        if let statusCodeError = getStatusCodeError(response) {
            return .failure(statusCodeError)
        }
        
        if let err = error {
            return .failure(.dataTaskError(err.localizedDescription))
        }
        
        guard let data = data else {
            return .failure(.corruptData)
        }
        
        do {
            return .success(try JSONDecoder().decode(T.self, from: data))
        } catch {
            return .failure(.decodingError(error.localizedDescription))
        }
    }
    
    // MARK:  Using Concurrency
    
    private func result<T: Decodable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
        
            if let statusCodeError = getStatusCodeError(response) {
                throw statusCodeError
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw CSError.decodingError(error.localizedDescription)
            }
        } catch {
            throw CSError.dataTaskError(error.localizedDescription)
        }
    }
    
    private func getRequest(for url: URL, and method: HTTPMethod, body: HTTPBody?) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            guard let data = body.data else {
                return nil
            }
            
            request.httpBody = data
            request.addValue(body.contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        if let auth = self.authorization {
            request.addValue(auth.value, forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        }
        
        return request
    }
    
    private func getStatusCodeError(_ response: URLResponse?) -> CSError? {
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

// MARK: - Service For Instances

extension CarotaService: Service {
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: HTTPBody? = nil, completion: @escaping Handler<T>) {
        guard let url = baseURL?.asURL()?.appendingPathComponent(endpoint) else {
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
    
    // MARK:  Using Concurrency
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: HTTPBody? = nil) async throws -> T {
        guard let url = baseURL?.asURL()?.appendingPathComponent(endpoint) else {
            throw CSError.invalidURL
        }
        
        guard let request = getRequest(for: url, and: method, body: body) else {
            throw CSError.encodingError
        }
        
        do {
            return try await result(request: request)
        } catch {
            throw error
        }
    }
    
}

// MARK: - For Singleton

extension CarotaService: ServiceSingleton {
    
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get,  body: HTTPBody? = nil, completion: @escaping Handler<T>) {
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
    
    // MARK:  Using Concurrency
    
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get, body: HTTPBody? = nil) async throws -> T {
        guard let url = convertible.asURL() else {
            throw CSError.invalidURL
        }
        
        guard let request = getRequest(for: url, and: method, body: body) else {
            throw CSError.encodingError
        }
        
        do {
            return try await result(request: request)
        } catch {
            throw error
        }
    }
    
}

