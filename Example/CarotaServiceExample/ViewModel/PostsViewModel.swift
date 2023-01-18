//
//  PostsViewModel.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation
import CarotaService

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    var userId: Int
    
    var service = MPService(baseURL: "https://jsonplaceholder.typicode.com")
    
    typealias PostsResult = MPService.Output<[Post]>
    
    init(userId: Int) {
        self.userId = userId
    }
    
    @MainActor
    func fetchPosts() {
        isLoading.toggle()
        service.request("/users/\(userId)/posts") { (result: PostsResult) in
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
    
    func createPost(user: User) {
        service.request("/posts", method: .post, body: .json(object: user)) { (result: MPService.Output<User>) in
            switch result {
            case .success(let postcreated):
                DispatchQueue.main.async {
                    print(postcreated)
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
