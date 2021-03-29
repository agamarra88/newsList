//
//  ArticleListView.swift
//  AGM-Hodinkee
//
//  Created by Arturo Gamarra on 3/28/21.
//

import SwiftUI
import URLImage
import Model

struct ArticleListView: View {
    
    @ObservedObject private var viewModel = DILocator.shared.makeArticleListViewModel()
    @State private var showAddArticle: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.articles, id: \Article.title) { article in
                    ArticleRowView(article: article)
                        .deleteDisabled(article.id == nil)
                        .onAppear(perform: {
                            if viewModel.shouldLoadNextPage(after: article) {
                                viewModel.loadNextPage()
                            }
                        })
                }
                .onDelete(perform: { indexSet in
                    viewModel.delete(in: Array(indexSet))
                })
            }
            .id(UUID())
            .alert(isPresented: $viewModel.showError, content: {
                Alert(title: Text("Error"), message: Text(viewModel.error!.localizedDescription))
            })
            .onAppear(perform: {
                viewModel.refresh()
            })
            .navigationBarTitle(Text("HODINKEE"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showAddArticle = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
            .sheet(isPresented: $showAddArticle, content: {
                ArticleView(article: Article()) { _ in
                    showAddArticle = false
                    viewModel.refresh()
                }
            })
        }
    }
}

struct ArticleRowView: View {
    
    @State private var hideImage = false
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            if article.hasImage {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 200)
                    if let data = article.imageData {
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            
                    } else {
                        URLImage(url: article.imageURL!) {  image  in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .clipped()
                        }
                    }
                }
            }
            Group {
                Text(article.source.name)
                    .bold()
                    .foregroundColor(.gray)
                +
                Text(" \(article.title)")
                    .bold()
            }
            .font(.title3)
            .padding(.vertical)
            Group {
                if let author = article.author {
                    Text("\(author) · ")
                        .foregroundColor(.black) +
                    Text(article.mediumDate)
                        .foregroundColor(Color(UIColor.darkGray))
                } else {
                    Text(article.mediumDate)
                        .foregroundColor(Color(UIColor.darkGray))
                }
            }
            .font(.callout)
            .padding(.bottom)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        DILocator.shared.inMemory = true
        return ArticleListView()
    }
}
