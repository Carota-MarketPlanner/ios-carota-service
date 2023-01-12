//
//  UsersView.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import SwiftUI

struct UsersView: View {
    
    @StateObject var viewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink {
                        PostsView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name).font(.title3)
                            Text(user.email)
                        }
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
            .navigationTitle("Users")
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
