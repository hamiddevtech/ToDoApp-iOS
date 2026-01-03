//
//  MockRemoteTodoFetcher.swift
//  ToDoAppTests
//
//  Created by Hamid Mahmood on 12/31/25.
//

import XCTest
@testable import ToDoApp

// MARK: - Success Mock

/// Mock fetcher that returns configurable to-do items.
final class MockRemoteTodoFetcher: RemoteTodoFetching {
    
    var remoteTodos: [RemoteTodo] = [
        RemoteTodo(userId: 123, id: 11122, title: "Shipment Dropoff", completed: false)
    ]
    
    var mockError: Error?
    
    func fetchRemoteTodos() async throws -> [RemoteTodo] {
        if let error = mockError {
            throw error
        }
        return remoteTodos
    }
}

// MARK: - Failure Mock

/// Mock fetcher that always throws an error.
final class MockRemoteTodoFetcherFailure: RemoteTodoFetching {
    
    var errorToThrow: Error = RemoteNetworkError.invalidResponse
    
    func fetchRemoteTodos() async throws -> [RemoteTodo] {
        throw errorToThrow
    }
}
