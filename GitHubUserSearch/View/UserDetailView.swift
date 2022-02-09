//
//  UserDetailView.swift
//  GitHubUserSearch
//
//  Created by yorifuji on 2022/02/08.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    var body: some View {
        VStack {
            UserInformationView(user: user)
            RepositoryListView(user: user)
        }
    }
}

struct UserInformationView: View {
    let user: User
    @ObservedObject var viewModel = GitHubUser()
    var body: some View {
        VStack {
            if let userInfo = viewModel.userInfo {
                UserInformationCard(userInfo: userInfo)
            }
        }
        .onAppear {
            viewModel.getUser(url: user.url)
        }
    }
}

struct UserInformationCard: View {
    let userInfo: UserInformation
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: userInfo.image ?? UIImage())
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                VStack {
                    HStack {
                        Text(userInfo.name ?? "")
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Text(userInfo.login)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                Spacer()
            }
            HStack {
                HStack {
                    Text(String(userInfo.followers))
                        .fontWeight(.bold)
                    Text("フォロワー")
                    Spacer()
                }
                HStack {
                    Text(String(userInfo.following))
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
}

struct UserInformationCard_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationCard(userInfo: UserInformation(login: "test", name: "Test", followers: 0, following: 0, image: UIImage(systemName: "person.fill")))
            .previewLayout(.sizeThatFits)
    }
}


struct RepositoryListView: View {
    let user: User
    @ObservedObject var viewModel = GitHubUserRepository()
    var body: some View {
        List {
            ForEach(viewModel.repositories) { repo in
                if !repo.fork {
                    NavigationLink(destination: WebView(url: repo.htmlUrl)) {
                        RepositoryRow(repository: repo)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModel.getRepository(url: user.reposUrl)
        }
    }
}

struct RepositoryRow: View {
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
        .padding()
    }
}

struct RepositoryRow_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryRow(repository: Repository(id: 0, name: "Name", fullName: "Full Name", language: "Swift", stargazersCount: 0, fork: false, description: "Test Repository", htmlUrl: "http://github.com"))
            .previewLayout(.sizeThatFits)
    }
}
