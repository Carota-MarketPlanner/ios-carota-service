//
//  MPService.swift
//  MPService
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation

public class MPService: Service {
    
    let baseURL: String
    
    public init(baseURL: String) { self.baseURL = baseURL }
    
    public func request<T: Decodable>(_ endpoint: String,
                           method: HTTPMethod = .GET,
                           dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                           keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        
        guard let url = URL(string: baseURL+endpoint) else {
            throw MPService.Error.invalidURL
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
//            request.allHTTPHeaderFields = [
//                "Content-Type": contentType,
//                "Authorization": "Token \(token)"
//            ]
        
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw MPService.Error.invalidResponseStatus
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let users = try decoder.decode(T.self, from: data)
                return users
            } catch {
                throw MPService.Error.decodinError(error.localizedDescription)
            }
            
        } catch {
            throw MPService.Error.dataTaskError(error.localizedDescription)
        }
        
    }
    
    public func request<T: Decodable>(_ endpoint: String,
                           method: HTTPMethod = .GET,
                           dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                           keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                           completion: @escaping (Result<T, MPService.Error>) -> Void) {
        
        guard let url = URL(string: baseURL+endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
//        request.allHTTPHeaderFields = [
//            "Content-Type": contentType,
//            "Authorization": "Token \(token)"
//        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponseStatus))
                return
            }
            
            guard error == nil else {
                completion(.failure(.dataTaskError(error?.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.corruptData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let users = try decoder.decode(T.self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(.decodinError(error.localizedDescription)))
            }
        }
        
        task.resume()
    }
}

