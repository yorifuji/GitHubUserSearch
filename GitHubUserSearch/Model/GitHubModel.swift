//
//  GitHubModel.swift
//  GitHubUserSearch
//
//  Created by yorifuji on 2022/02/07.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    let reposUrl: String
    let url: String
}

struct SearchUsersResponse: Decodable {
    let items: [User]
}

struct UserResponse: Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let reposUrl: String
    let name: String?
    let followers: Int
    let following: Int
}

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let fork: Bool
    let description: String?
    let htmlUrl: String
}
