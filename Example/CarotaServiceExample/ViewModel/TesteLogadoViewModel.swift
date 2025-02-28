//
//  TesteLogadoViewModel.swift
//  CarotaService_Example
//
//  Created by Elias Ferreira on 24/01/23.
//

import Foundation
import CarotaService

class TesteLogadoViewModel {
    
    static let service = CSCloudClient.shared
    
    static func testConection(token: String) {
        
        service.setAuthorization(.bearer(token: token))
        
        service.request(url: "http://localhost:3333/user/getUsers") { (result: Result<[UserLogado], CSError>) in
            switch result {
            case .success(let users):
                print("Sucesso - \(users)")
            case .failure(let error):
                print("Falha - \(error.localizedDescription)")
            }
        }
        
    }
    
}
