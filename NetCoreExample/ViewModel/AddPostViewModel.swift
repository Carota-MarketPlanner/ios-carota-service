//
//  AddPostViewModel.swift
//  NetCoreExample
//
//  Created by Elias Ferreira on 14/01/23.
//

import Foundation
import NetCore

class AddPostViewModel: ObservableObject {
    var client = NCClient.shared
    
    @Published var title: String = ""
    @Published var body: String = ""
    
    let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func addPost() {
        let post = Post(userId: userId, id: 101, title: self.title, body: self.body)
        
        client.request(url: "https://jsonplaceholder.typicode.com/posts", method: .post, body: .json(object: post)) { (result: Result<Post, NCError>) in
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
