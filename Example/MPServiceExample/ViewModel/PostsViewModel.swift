//
//  PostsViewModel.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import Foundation
import MPService
import UIKit

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    var service = MPService(baseURL: "https://jsonplaceholder.typicode.com/")
    
    typealias PostsResult = MPService.Output<[Post]>
    
    @MainActor
    func fetchPosts(for userId: Int?) {
        if let userId = userId {
            isLoading.toggle()
            service.request("users/\(userId)/posts") { (result: PostsResult) in
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
