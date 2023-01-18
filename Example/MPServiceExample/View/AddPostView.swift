//
//  AddPostView.swift
//  MPService_Example
//
//  Created by Elias Ferreira on 13/01/23.
//

import SwiftUI

struct MyStyle: TextFieldStyle {
  
  func _body(configuration: TextField<_Label>) -> some View {
      configuration
          .textFieldStyle(PlainTextFieldStyle())
          .padding(13)
          .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(.gray, lineWidth: 1)
          )
  }
}

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
                    .textFieldStyle(MyStyle())
                
                TextField("Corpo: ", text: $viewModel.body)
                    .textFieldStyle(MyStyle())
                
                Spacer()
                
                Button {
                    savePost()
                } label: {
                    Label("Salvar", systemImage: "square.and.arrow.down")
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
