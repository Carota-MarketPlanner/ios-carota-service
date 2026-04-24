//
//  UsersViewModel.swift
//  NetCoreExample
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation
import NetCore

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    var client = NCClient.shared
    
    @MainActor
    func fetchUsers() async {
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        do {
            users = try await client.request(url: "https://jsonplaceholder.typicode.com/users")
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
