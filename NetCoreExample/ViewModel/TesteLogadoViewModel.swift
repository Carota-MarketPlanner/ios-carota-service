//
//  TesteLogadoViewModel.swift
//  NetCoreExample
//
//  Created by Elias Ferreira on 24/01/23.
//

import Foundation
import NetCore

class TesteLogadoViewModel {
    
    static let client = NCClient.shared
    
    static func testConection(token: String) {
        
        client.setAuthorization(.bearer(token: token))
        
        client.request(url: "http://localhost:3333/user/getUsers") { (result: Result<[UserLogado], NCError>) in
            switch result {
            case .success(let users):
                print("Sucesso - \(users)")
            case .failure(let error):
                print("Falha - \(error.localizedDescription)")
            }
        }
        
    }
    
}
