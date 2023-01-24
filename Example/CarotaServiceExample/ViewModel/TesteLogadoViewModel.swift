//
//  TesteLogadoViewModel.swift
//  CarotaService_Example
//
//  Created by Elias Ferreira on 24/01/23.
//

import Foundation
import CarotaService

class TesteLogadoViewModel {
    
    static var service = CarotaService.getInstance(for: "http://localhost:3333")
    
    static func testConection(token: String) {
        
        service.authorization = .bearer(token: token)
        
        service.request("/user/getUsers") { (result: Result<[UserLogado], CSError>) in
            switch result {
            case .success(let users):
                print("Cucesso - \(users)")
            case .failure(let error):
                print("Falha - \(error.localizedDescription)")
            }
        }
        
    }
    
}
