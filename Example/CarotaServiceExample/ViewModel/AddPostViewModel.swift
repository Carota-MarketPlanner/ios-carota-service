//
//  AddPostViewModel.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 14/01/23.
//

import Foundation
import CarotaService

class AddPostViewModel: ObservableObject {
    var service = CSCloudClient.shared
    
    @Published var title: String = ""
    @Published var body: String = ""
    
    let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func addPost() {
        let post = Post(userId: userId, id: 101, title: self.title, body: self.body)
        
        service.request(url: "https://jsonplaceholder.typicode.com/posts", method: .post, body: .json(object: post)) { (result: Result<Post, CSError>) in
            switch result {
            case .success(let postcreated):
                DispatchQueue.main.async {
                    print(postcreated)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
