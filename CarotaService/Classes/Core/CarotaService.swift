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
    
    public static let shared = CarotaService() as ServiceSingleton
    
    private init(baseURL: URLConvertible? = nil) {
        self.baseURL = baseURL
    }
    
    public static func getInstance(for baseURL: URLConvertible) -> Service {
        return CarotaService(baseURL: baseURL) as Service
    }
    
    private func getRequest(for url: URL, and method: HTTPMethod, body: HTTPBody?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            guard let data = body.data else {
                throw CSError.encodingError
            }
            
            request.httpBody = data
            request.addValue(body.contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        return request
    }
    
    private func result<T: Decodable>(data: Data?, response: URLResponse?, error: Swift.Error?) -> Output<T> {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            return .failure(.invalidResponseStatus)
        }
        
        guard error == nil else {
            return .failure(.dataTaskError(error?.localizedDescription))
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
        
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CSError.invalidResponseStatus
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
    
}

// MARK: - Service For Instances

extension CarotaService: Service {
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: HTTPBody? = nil, completion: @escaping Handler<T>) {
        guard let url = baseURL?.asURL()?.appendingPathComponent(endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let request = try getRequest(for: url, and: method, body: body)
            URLSession.shared.dataTask(with: request) {
                completion(self.result(data: $0, response: $1, error: $2))
            }.resume()
        } catch {
            completion(.failure(CSError.dataTaskError(error.localizedDescription)))
        }
    }
    
    // MARK:  Using Concurrency
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: HTTPBody? = nil) async throws -> T {
        guard let url = baseURL?.asURL()?.appendingPathComponent(endpoint) else {
            throw CSError.invalidURL
        }
        
        do {
            let request = try getRequest(for: url, and: method, body: body)
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

        do {
           let request = try getRequest(for: url, and: method, body: body)
            URLSession.shared.dataTask(with: request) {
                completion(self.result(data: $0, response: $1, error: $2))
            }.resume()
        } catch {
            completion(.failure(CSError.dataTaskError(error.localizedDescription)))
        }
    }
    
    // MARK:  Using Concurrency
    
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get, body: HTTPBody? = nil) async throws -> T {
        guard let url = convertible.asURL() else {
            throw CSError.invalidURL
        }
        
        do {
            let request = try getRequest(for: url, and: method, body: body)
            return try await result(request: request)
        } catch {
            throw error
        }
    }
    
}

