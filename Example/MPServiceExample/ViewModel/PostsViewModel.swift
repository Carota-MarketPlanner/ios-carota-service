//
//  PostsViewModel.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation
import MPService

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    var apiService = MPService(baseURL: "https://jsonplaceholder.typicode.com/")
    
    @MainActor
    func fetchPosts(for userId: Int?) async {
        if let userId = userId {
            isLoading.toggle()
            defer {
                isLoading.toggle()
            }
            do {
                posts = try await apiService.request("users/\(userId)/posts")
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }
}
