//
//  RemoteTodoFetcherTests.swift
//  ToDoAppTests
//
//  Created by Hamid Mahmood on 12/31/25.
//

import XCTest
@testable import ToDoApp

/// Unit tests for ``RemoteTodoFetcher``.
final class RemoteTodoFetcherTests: XCTestCase {
    
    var sut: RemoteTodoFetching!
    
    override func setUp() {
        super.setUp()
        sut = MockRemoteTodoFetcher()
    }
    
    // MARK: - Success Tests
    
    func testFetchRemoteTodos_success() async throws {
        // Valid JSON matching the expected RemoteTodo model
        let json = """
        [
            { "userId": 123, "id": 1, "title": "Test", "completed": false }
        ]
        """.data(using: .utf8)!
        
        // Simulate a successful HTTP response
        let response = HTTPURLResponse(
            url: URL(string: "https://jsonplaceholder.typicode.com/todos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        // Configure mock session with valid data and response
        let session = MockURLSession()
        session.data = json
        session.urlResponse = response
        
        let sut = await RemoteTodoFetcher(session: session)
        
        let todos = try await sut.fetchRemoteTodos()
        
        XCTAssertEqual(todos.count, 1)
        let userId = await MainActor.run { todos.first?.userId }
        XCTAssertEqual(userId, 123)
    }
    
    // MARK: - Error Tests
    
    func testFetchRemoteTodos_invalidStatusCode() async {
        let response = HTTPURLResponse(
            url: URL(string: "https://jsonplaceholder.typicode.com/todos")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let session = MockURLSession()
        session.data = Data("{}".utf8)
        session.urlResponse = response
        
        let sut = await RemoteTodoFetcher(session: session)
        
        do {
            _ = try await sut.fetchRemoteTodos()
            XCTFail("Expected error for invalid status code")
        } catch {
            XCTAssertTrue(error is RemoteNetworkError)
        }
    }
    
    func testFetchRemoteTodos_invalidData() async {
        let response = HTTPURLResponse(
            url: URL(string: "https://jsonplaceholder.typicode.com/todos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let session = MockURLSession()
        session.data = Data() // Empty payload
        session.urlResponse = response
        
        let sut = await RemoteTodoFetcher(session: session)
        
        do {
            _ = try await sut.fetchRemoteTodos()
            XCTFail("Expected error for empty data")
        } catch {
            XCTAssertTrue(error is RemoteNetworkError)
        }
    }
    
    func testFetchRemoteTodos_invalidResponse() async {
        let session = MockURLSession()
        session.data = Data("{}".utf8)
        
        // Intentionally NOT an HTTPURLResponse to fail the type cast
        session.urlResponse = URLResponse(
            url: URL(string: "https://jsonplaceholder.typicode.com/todos")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        let sut = await RemoteTodoFetcher(session: session)
        
        do {
            _ = try await sut.fetchRemoteTodos()
            XCTFail("Expected invalidResponse error")
        } catch {
            XCTAssertTrue(error is RemoteNetworkError)
        }
    }
    
    func testFetchRemoteTodos_decodingFailure() async {
        let invalidJSON = """
        [
            { "unexpected": "field" }
        ]
        """.data(using: .utf8)!
        
        let response = HTTPURLResponse(
            url: URL(string: "https://jsonplaceholder.typicode.com/todos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        let session = MockURLSession()
        session.data = invalidJSON
        session.urlResponse = response
        
        let sut = await RemoteTodoFetcher(session: session)
        
        do {
            _ = try await sut.fetchRemoteTodos()
            XCTFail("Expected decodingFailed error")
        } catch let error as RemoteNetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
