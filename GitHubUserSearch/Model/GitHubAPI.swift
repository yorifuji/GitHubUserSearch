//
//  GitHubAPI.swift
//  GitHubUserSearch
//
//  Created by yorifuji on 2022/02/07.
//

import Foundation
import Combine

private let GITHUB_PAT = ""

enum Failure: Error {
    case createURLError
    case urlError(URLError)
    case responseError
    case statusError(Int)
    case decodeError(Error)
}

protocol GitHubAPIProtocol {
    static func searchUsers(username: String) -> AnyPublisher<SearchUsersResponse, Failure>
    static func getUser(url: String) -> AnyPublisher<UserResponse, Failure>
    static func getRepository(url: String) -> AnyPublisher<[Repository], Failure>
}

enum GitHubAPIClient: GitHubAPIProtocol {

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private static func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        if GITHUB_PAT.isEmpty == false {
            request.addValue("token \(GITHUB_PAT)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    static func searchUsers(username: String) -> AnyPublisher<SearchUsersResponse, Failure> {
        let baseURL = "https://api.github.com/search/users?q="

        guard let url = URL(string: baseURL + username) else {
            return Fail(error: Failure.createURLError).eraseToAnyPublisher()
        }

        let request = makeRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                Failure.urlError(error)
            }
            .tryMap { (data, response) -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw Failure.responseError
                }
                if (200..<300).contains(httpRes.statusCode) == false {
                    throw Failure.statusError(httpRes.statusCode)
                }
                return data
            }
            .decode(type: SearchUsersResponse.self, decoder: decoder)
            .mapError { $0 as? Failure ?? .decodeError($0) }
            .eraseToAnyPublisher()
    }

    static func getUser(url: String) -> AnyPublisher<UserResponse, Failure> {
        guard let url = URL(string: url) else {
            return Fail(error: Failure.createURLError).eraseToAnyPublisher()
        }

        let request = makeRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                Failure.urlError(error)
            }
            .tryMap { (data, response) -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw Failure.responseError
                }
                if (200..<300).contains(httpRes.statusCode) == false {
                    throw Failure.statusError(httpRes.statusCode)
                }
                return data
            }
            .decode(type: UserResponse.self, decoder: decoder)
            .mapError { $0 as? Failure ?? .decodeError($0) }
            .eraseToAnyPublisher()
    }

    static func getRepository(url: String) -> AnyPublisher<[Repository], Failure> {
        guard let url = URL(string: url) else {
            return Fail(error: Failure.createURLError).eraseToAnyPublisher()
        }

        let request = makeRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                Failure.urlError(error)
            }
            .tryMap { (data, response) -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw Failure.responseError
                }
                if (200..<300).contains(httpRes.statusCode) == false {
                    throw Failure.statusError(httpRes.statusCode)
                }
                return data
            }
            .decode(type: [Repository].self, decoder: decoder)
            .mapError { $0 as? Failure ?? .decodeError($0) }
            .eraseToAnyPublisher()
    }
}
