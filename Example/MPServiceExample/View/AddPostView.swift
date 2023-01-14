//
//  AddPostView.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 13/01/23.
//

import SwiftUI

struct AddPostView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: AddPostViewModel
    
    init(userId: Int) {
        _viewModel = StateObject(wrappedValue: AddPostViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                TextField("Título: ", text: $viewModel.title)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Corpo: ", text: $viewModel.body)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                
                Button{
                    savePost()
                } label: {
                    Label("Salvar",
                          systemImage: "square.and.arrow.down")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
            }
            .padding(20)
            .navigationTitle("Add Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        savePost()
                    }
                }
            }
        }
    }
    
    private func savePost() {
        viewModel.addPost()
        dismiss()
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView(userId: 1)
    }
}
