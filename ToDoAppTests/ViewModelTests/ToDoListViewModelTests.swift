//
//  ToDoListViewModelTests.swift
//  ToDoAppTests
//
//  Created by Hamid Mahmood on 12/31/25.
//

import XCTest
import CoreData
@testable import ToDoApp

/// Unit tests for ``ToDoListViewModel``.
///
/// ``ToDoListViewModelTests`` verifies the correctness of the to-do list
/// view model’s behavior, including:
///
/// - Creating and persisting new to-do items
/// - Deleting existing to-do items
/// - Fetching and persisting remote to-do items
/// - Preventing duplication during remote synchronization
/// - Exposing user-facing error state
///
/// ## Test Environment
/// All tests run against an in-memory Core Data store provided by
/// ``TestPersistenceController`` to ensure isolation, determinism,
/// and zero side effects.
///
/// ## Threading
/// These tests are executed on the main actor and operate on a
/// main-queue-bound managed object context.
@MainActor
final class ToDoListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    /// An in-memory persistence controller used for testing.
    private var persistence: TestPersistenceController!
    
    /// The managed object context under test.
    private var context: NSManagedObjectContext!
    
    /// The view model instance under test.
    private var viewModel: ToDoListViewModel!
    
    // MARK: - Setup and Teardown
    
    /// Sets up a fresh in-memory Core Data stack and view model
    /// before each test executes.
    override func setUp() {
        super.setUp()
        
        persistence = TestPersistenceController()
        context = persistence.viewContext
        
        // Ensure a clean context for each test case.
        context.reset()
        
        viewModel = ToDoListViewModel(context: context)
    }
    
    override func tearDown() {
        viewModel = nil
        context = nil
        persistence = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func fetchTodos() throws -> [ToDoEntity] {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ToDoEntity.id, ascending: true)
        ]
        return try context.fetch(request)
    }
    
    // MARK: - Add To-Do Tests
    
    func testAddTodo_createsOneTodo() throws {
        viewModel.addTodo(title: "Test", status: false)
        
        let todos = try fetchTodos()
        XCTAssertEqual(todos.count, 1)
    }
    
    func testAddTodo_savesCorrectTitle() throws {
        viewModel.addTodo(title: "Buy groceries", status: false)
        
        let todos = try fetchTodos()
        XCTAssertEqual(todos.first?.title, "Buy groceries")
    }
    
    func testAddTodo_setsCompletedFalse() throws {
        viewModel.addTodo(title: "Task", status: false)
        
        let todos = try fetchTodos()
        XCTAssertEqual(todos.first?.completed, false)
    }
    
    func testAddTodo_assignsId() throws {
        viewModel.addTodo(title: "Task with ID", status: false)
        
        let todos = try fetchTodos()
        XCTAssertNotEqual(todos.first?.id, 0)
    }
    
    // MARK: - Delete To-Do Tests
    
    func testDeleteTodo_removesItem() throws {
        viewModel.addTodo(title: "Delete me", status: false)
        
        let todo = try fetchTodos().first!
        viewModel.deleteTodo(todo)
        
        XCTAssertTrue(try fetchTodos().isEmpty)
    }
    
    func testDeleteTodo_onlyDeletesSelectedItem() throws {
        viewModel.addTodo(title: "Keep", status: false)
        viewModel.addTodo(title: "Delete", status: false)
        
        let todos = try fetchTodos()
        let deleteTarget = todos.first { $0.title == "Delete" }!
        
        viewModel.deleteTodo(deleteTarget)
        
        let remaining = try fetchTodos()
        XCTAssertEqual(remaining.count, 1)
        XCTAssertEqual(remaining.first?.title, "Keep")
    }
    
    // MARK: - Remote To-Do Tests
    
    func testFetchRemoteTodos_savesTodos() async throws {
        let mock = MockRemoteTodoFetcher()
        mock.remoteTodos = [
            RemoteTodo(userId: 1, id: 1, title: "Remote 1", completed: false),
            RemoteTodo(userId: 1, id: 2, title: "Remote 2", completed: true)
        ]
        
        viewModel = ToDoListViewModel(
            context: context,
            remoteTodoFetcher: mock
        )
        
        await viewModel.fetchRemoteTodos()
        
        let todos = try fetchTodos()
        XCTAssertEqual(todos.count, 2)
    }
    
    /// Verifies that fetching remote to-do items multiple times
    /// does not create duplicate entries.
    func testFetchRemoteTodos_doesNotDuplicate() async throws {
        let mock = MockRemoteTodoFetcher()
        mock.remoteTodos = [
            RemoteTodo(userId: 1, id: 99, title: "Remote", completed: false)
        ]
        
        viewModel = ToDoListViewModel(
            context: context,
            remoteTodoFetcher: mock
        )
        
        await viewModel.fetchRemoteTodos()
        await viewModel.fetchRemoteTodos()
        
        XCTAssertEqual(try fetchTodos().count, 1)
    }
    
    // MARK: - Error Handling Tests
    
    func testFetchRemoteTodos_setsErrorMessage() async {
        let mock = MockRemoteTodoFetcherFailure()
        
        viewModel = ToDoListViewModel(
            context: context,
            remoteTodoFetcher: mock
        )
        
        await viewModel.fetchRemoteTodos()
        
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
