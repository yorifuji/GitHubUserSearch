//
//  UserSearchView.swift
//  GitHubUserSearch
//
//  Created by yorifuji on 2022/02/08.
//

import SwiftUI

struct UserSearchView: View {
    @ObservedObject var userListModel = GitHubUsers()
    @State private var username = ""
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField(
                        "ユーザーを検索",
                        text: $username
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            userListModel.searchUser(username: username)
                        }
                    Button("検索") {
                        userListModel.searchUser(username: username)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1.0))
                .padding()
                List {
                    ForEach(userListModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            SearchUserRow(user: user)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("ホーム")
        }
    }
}

struct SearchUserRow: View {
    let user: User
    @State var image: UIImage?
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
            }
            Text(user.login)
        }
        .onAppear {
            downloadImageAsync(url: URL(string: user.avatarUrl)!) { image in
                self.image = image
            }
        }
    }
}

struct SearchUserRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserRow(user: User(
            id: 0,
            login: "Test User!!!",
            avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4",
            reposUrl: "",
            url: "")).previewLayout(.sizeThatFits)
    }
}
