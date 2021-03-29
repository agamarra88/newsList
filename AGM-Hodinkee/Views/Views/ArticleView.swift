//
//  ArticleView.swift
//  AGM-Hodinkee
//
//  Created by Arturo Gamarra on 3/29/21.
//

import SwiftUI
import UIKit
import Model

struct ArticleView: View {
    
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: ArticleEditViewModel
    @State private var showSelectImage: Bool = false
    private var onComplete: (Article) -> Void
    
    // MARK: - Constructor
    init(article: Article, onComplete: @escaping (Article) -> Void) {
        self.onComplete = onComplete
        self.viewModel = DILocator.shared.makeArticleEditViewModel(article: article)
    }
    
    // MARK: - Views
    var photoImage: some View {
        if let imagen = viewModel.selectedImage {
            return Image(uiImage: imagen)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
        } else {
            return Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipped()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        photoImage
                            .foregroundColor(Color(UIColor.darkGray))
                            .onTapGesture {
                                showSelectImage = true
                            }
                            .sheet(isPresented: $showSelectImage, content: {
                                ImagePickerView(imagen: $viewModel.selectedImage, sourceType: .photoLibrary)
                            })
                        
                        VStack(alignment: .leading) {
                            Text("Title:")
                            TextField("Ej: Article 1", text: $viewModel.article.title)
                        }
                        .padding()
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Content:")
                            TextEditor(text: $viewModel.article.content)
                                .frame(minHeight: 200)
                        }
                        .padding(.horizontal)
                    }
                }
                Button(action: {
                    if viewModel.validateForm() {
                        viewModel.store(completion: onComplete)
                    }
                }, label: {
                    Text("Save")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                })
                .background(Color.green)
                .cornerRadius(10)
                .alert(isPresented: $viewModel.showValidationError, content: {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.errorMessage))
                })
            }
            .padding()
            .navigationBarTitle(Text(viewModel.article.id == nil ? "New Article" : "Edit Article"),
                                displayMode: .inline)
            .navigationBarItems(leading:
                                    Button("Cancel", action: {
                                        presentationMode.wrappedValue.dismiss()
                                    })
            )
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        DILocator.shared.inMemory = true
        return ArticleView(article: Article()) { _ in
            
        }
    }
}
