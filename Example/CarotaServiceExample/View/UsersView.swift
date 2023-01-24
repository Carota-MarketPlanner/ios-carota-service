//
//  UsersView.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 11/01/23.
//

import SwiftUI

struct UsersView: View {
    
    @StateObject var viewModel = UsersViewModel()
    @State private var showingAlert = false
    @State var token: String = ""
    
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                NavigationLink(destination: PostsView(userId: user.id)) {
                    VStack(alignment: .leading) {
                        Text(user.name).font(.title3)
                        Text(user.email)
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
            .toolbar {
                Button("Teste Logado") {
                    showingAlert.toggle()
                }
                .alert("Token?", isPresented: $showingAlert) {
                    TextField("Digite o token:", text: $token)
                    Button("OK", action: submit)
                }
            }
        }
    }
    
    func submit() {
        TesteLogadoViewModel.testConection(token: token)
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
