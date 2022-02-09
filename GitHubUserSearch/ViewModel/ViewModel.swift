//
//  ViewModel.swift
//  GitHubRepositorySearchSwiftUI
//
//  Created by yorifuji on 2022/02/06.
//

import Foundation
import Combine

class GitHubUsers: ObservableObject {
    @Published var users: [User] = []
    var cancellables = Set<AnyCancellable>()

    func searchUser(username: String) -> Void {
        GitHubAPIClient.searchUsers(username: username).sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                switch error {
                case .createURLError:
                    print("createURL error")
                case .urlError(let error):
                    print("urlError: \(error.localizedDescription)")
                case .decodeError(let error):
                    print("decode error: \(error.localizedDescription)")
                case .responseError:
                    print("responseError")
                case .statusError(let status):
                    print("statusError: \(status)")
                }
            }
        } receiveValue: { response in
            print(response)
            self.users = response.items
        }
        .store(in: &cancellables)

    }
}

class GitHubUser: ObservableObject {
    @Published var userInfo: UserInformation?
    var cancellables = Set<AnyCancellable>()

    func getUser(url: String) -> Void {
        GitHubAPIClient.getUser(url: url).sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                switch error {
                case .createURLError:
                    print("createURL error")
                case .urlError(let error):
                    print("urlError: \(error.localizedDescription)")
                case .decodeError(let error):
                    print("decode error: \(error.localizedDescription)")
                case .responseError:
                    print("responseError")
                case .statusError(let status):
                    print("statusError: \(status)")
                }
            }
        } receiveValue: { response in
            print(response)
            let user = response
            downloadImageAsync(url: URL(string: user.avatarUrl)!) { image in
                self.userInfo = UserInformation(
                    login: user.login,
                    name: user.name,
                    followers: user.followers,
                    following: user.following,
                    image: image)
            }
        }
        .store(in: &cancellables)

    }
}

class GitHubUserRepository: ObservableObject {
    @Published var repositories: [Repository] = []

    var cancellables = Set<AnyCancellable>()

    func getRepository(url: String) -> Void {
        GitHubAPIClient.getRepository(url: url).sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                switch error {
                case .createURLError:
                    print("createURL error")
                case .urlError(let error):
                    print("urlError: \(error.localizedDescription)")
                case .decodeError(let error):
                    print("decode error: \(error.localizedDescription)")
                case .responseError:
                    print("responseError")
                case .statusError(let status):
                    print("statusError: \(status)")
                }
            }
        } receiveValue: { response in
            print(response)
            self.repositories = response
        }
        .store(in: &cancellables)

    }
}
