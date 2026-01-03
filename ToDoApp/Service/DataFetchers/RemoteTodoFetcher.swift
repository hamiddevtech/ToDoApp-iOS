//
//  RemoteTodoFetcher.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/31/25.
//

import Foundation

// MARK: - URL Session Protocol

/// Abstracts URL session for testability.
protocol URLSessioning {
    
    /// Fetches data from the specified URL.
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessioning {}

// MARK: - Remote Todo Fetching Protocol

/// Defines interface for fetching to-dos from a remote source.
protocol RemoteTodoFetching {
    
    /// Fetches to-dos from the remote endpoint.
    func fetchRemoteTodos() async throws -> [RemoteTodo]
}

// MARK: - Remote Todo Fetcher

/// Fetches to-do items from the JSONPlaceholder API.
final class RemoteTodoFetcher: RemoteTodoFetching {
    
    // MARK: - Properties
    
    /// URL session for network requests.
    private let session: URLSessioning
    
    // MARK: - Initialization
    
    /// Creates a fetcher with the specified session.
    init(session: URLSessioning = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - RemoteTodoFetching
    
    /// Fetches to-dos from the remote API.
    func fetchRemoteTodos() async throws -> [RemoteTodo] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            throw RemoteNetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RemoteNetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RemoteNetworkError.invalidStatusCode(httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw RemoteNetworkError.invalidData
        }
        
        do {
            return try JSONDecoder().decode([RemoteTodo].self, from: data)
        } catch {
            throw RemoteNetworkError.decodingFailed
        }
    }
}
