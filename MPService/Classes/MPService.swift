//
//  MPService.swift
//  MPService
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

public class MPService: Service {
    
    public typealias MPResult<T> = Result<T, MPError>
    public typealias Handler<T> = (MPResult<T>) -> Void
    
    let baseURL: String
    
    public init(baseURL: String) { self.baseURL = baseURL }
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get) async throws -> T {
        
        guard let url = URL(string: baseURL+endpoint) else {
            throw MPError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: getRequest(for: url, and: method))
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw MPError.invalidResponseStatus
            }
            
            do {
                let users = try JSONDecoder().decode(T.self, from: data)
                return users
            } catch {
                throw MPError.decodinError(error.localizedDescription)
            }
            
        } catch {
            throw MPError.dataTaskError(error.localizedDescription)
        }
        
    }
    
    public func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, completion: @escaping Handler<T>) {
        
        guard let url = URL(string: baseURL+endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: getRequest(for: url, and: method)) {
            completion(self.result(data: $0, response: $1, error: $2))
        }
        
        task.resume()
    }
    
    func result<T: Decodable>(data: Data?, response: URLResponse?, error: Swift.Error?) -> MPResult<T> {
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
            let users = try JSONDecoder().decode(T.self, from: data)
            return .success(users)
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

