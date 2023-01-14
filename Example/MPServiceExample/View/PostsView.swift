//
//  PostsView.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import SwiftUI

struct PostsView: View {
    @StateObject var viewModel: PostViewModel
    @State var showAddPost = false
    
    init(userId: Int) {
        _viewModel = StateObject(wrappedValue: PostViewModel(userId: userId))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title).font(.headline)
                    Text(post.body).font(.callout).foregroundColor(.secondary)
                }
            }
        }
        .overlay(content: {
            if viewModel.isLoading {
                ProgressView()
            }
        })
        .alert("Application Error", isPresented: $viewModel.showAlert, actions: {
            Button("OK") {}
        }, message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        })
        .navigationTitle("Posts")
        .toolbar {
            Button {
                showAddPost.toggle()
            } label: {
                Label("", systemImage: "plus")
            }
            .sheet(isPresented: $showAddPost) {
                AddPostView(userId: viewModel.userId)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchPosts()
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(userId: 1)
    }
}

