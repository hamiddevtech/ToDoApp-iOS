//
//  MockURLSession.swift
//  ToDoAppTests
//
//  Created by Hamid Mahmood on 12/31/25.
//

import Foundation
@testable import ToDoApp

/// Mock URL session for testing network operations.
final class MockURLSession: URLSessioning {
    
    var data: Data = Data()
    var urlResponse: URLResponse!
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        return (data, urlResponse)
    }
}
