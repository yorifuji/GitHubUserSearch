//
//  UserDetailView.swift
//  GitHubUserSearch
//
//  Created by yorifuji on 2022/02/08.
//

import SwiftUI

struct UserDetailView: View {
    @ObservedObject var userModel = GitHubUser()
    @ObservedObject var userRepositoryModel = GitHubUserRepository()
    @State var image: UIImage?
    let user: User
    var body: some View {
        VStack {
            if let user = userModel.user {
                VStack {
                    if let image = image {
                        HStack {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                                .clipShape(Circle())
                            VStack {
                                HStack {
                                    Text(user.name ?? "")
                                        .font(.title)
                                    Spacer()
                                }
                                HStack {
                                    Text(user.login)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    }
                    HStack {
                        HStack {
                            Text(String(user.followers))
                                .fontWeight(.bold)
                            Text("フォロワー")
                            Spacer()
                        }
                        HStack {
                            Text(String(user.following))
                                .fontWeight(.bold)
                            Text("フォロー中")
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1.0))
                .padding()
            }
            List {
                ForEach(userRepositoryModel.repositories) { repo in
                    if !repo.fork {
                        NavigationLink(destination: WebView(url: repo.htmlUrl)) {
                            RepositoryDetailView(repository: repo)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            userModel.getUser(url: user.url)
            userRepositoryModel.getRepository(url: user.reposUrl)
            downloadImageAsync(url: URL(string: user.avatarUrl)!) { image in
                self.image = image
            }
        }
    }
}

struct RepositoryDetailView: View {
    let repository: Repository
    var body: some View {
        VStack {
            HStack {
                Text(repository.name)
                    .font(.headline)
                Spacer()
            }
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text("\(repository.stargazersCount) Star")
                }
                HStack {
                    Text(repository.language ?? "")
                    Spacer()
                }
            }
            HStack {
                Text(repository.description ?? "")
                Spacer()
            }
        }
    }
}
