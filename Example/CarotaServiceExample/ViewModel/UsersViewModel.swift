//
//  UsersViewModel.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation
import CarotaService

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    var service = CarotaService.getInstance(for: "https://jsonplaceholder.typicode.com")
    
    @MainActor
    func fetchUsers() async {
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        do {
            users = try await service.request("/users")
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
