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
    
    var service = MPService(baseURL: "https://jsonplaceholder.typicode.com/")
    
    @MainActor
    func fetchPosts(for userId: Int?) async {
        if let userId = userId {
            isLoading.toggle()
            service.request("users/\(userId)/posts") { (result: Result<[Post], MPService.Error>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.errorDescription
                    }
                }
            }
        }
    }
}
