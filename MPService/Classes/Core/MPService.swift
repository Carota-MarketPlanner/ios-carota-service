//
//  MPService.swift
//  MPService
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

public class MPService: Service {
    
    public typealias Output<T> = Result<T, MPError>
    public typealias Handler<T> = (Output<T>) -> Void
    
    let baseURL: URLConvertible?
    
    public init(baseURL: URLConvertible? = nil) {
        self.baseURL = baseURL
    }
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get) async throws -> T {
        guard let url = baseURL?.asURL()?.appendingPathComponent(endpoint) else {
            throw MPError.invalidURL
        }
        
        do {
            return try await result(request: getRequest(for: url, and: method))
        } catch {
            throw MPError.dataTaskError(error.localizedDescription)
        }
    }
    
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get) async throws -> T {
        guard let url = convertible.asURL() else {
            throw MPError.invalidURL
        }
        
        do {
            return try await result(request: getRequest(for: url, and: method))
        } catch {
            throw MPError.dataTaskError(error.localizedDescription)
        }
    }
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, completion: @escaping Handler<T>) {
        guard let url = baseURL?.asURL()?.appendingPathComponent(endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: getRequest(for: url, and: method)) {
            completion(self.result(data: $0, response: $1, error: $2))
        }.resume()
    }
    
    public func request<T: Decodable>(url convertible: URLConvertible, method: HTTPMethod = .get, completion: @escaping Handler<T>) {
        guard let url = convertible.asURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: getRequest(for: url, and: method)) {
            completion(self.result(data: $0, response: $1, error: $2))
        }.resume()
    }
    
    func result<T: Decodable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
        
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw MPError.invalidResponseStatus
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw MPError.decodinError(error.localizedDescription)
            }
        } catch {
            throw MPError.dataTaskError(error.localizedDescription)
        }
    }
    
    func result<T: Decodable>(data: Data?, response: URLResponse?, error: Swift.Error?) -> Output<T> {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
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
            return .failure(.decodinError(error.localizedDescription))
        }
    }
    
  
    
    func getRequest(for url: URL, and method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
//        request.allHTTPHeaderFields = [
//            "Content-Type": contentType,
//            "Authorization": "Token \(token)"
//        ]
        
        return request
    }
}

