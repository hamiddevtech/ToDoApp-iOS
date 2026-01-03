//
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/31/25.
//

import Foundation
import CoreData
import Combine

/// Handles business logic for the to-do list feature.
///
/// Manages CRUD operations for to-do items and fetches remote data.
final class ToDoListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// User-facing error message when an operation fails.
    @Published private(set) var errorMessage: String?
    
    // MARK: - Private Properties
    
    /// Core Data context for persistence.
    private let context: NSManagedObjectContext
    
    /// Service for fetching remote to-do items.
    private let remoteTodoFetcher: RemoteTodoFetching
    
    // MARK: - Initialization
    
    /// Creates a view model with the specified dependencies.
    init(
        context: NSManagedObjectContext,
        remoteTodoFetcher: RemoteTodoFetching = RemoteTodoFetcher()
    ) {
        self.context = context
        self.remoteTodoFetcher = remoteTodoFetcher
    }
    
    /// Adds a new to-do item.
    func addTodo(title: String, status: Bool) {
        let todo = ToDoEntity(context: context)
        todo.id = Int64(Date().timeIntervalSince1970)
        todo.title = title
        todo.completed = status
        saveContext()
    }
    
    /// Deletes a to-do item.
    func deleteTodo(_ todo: ToDoEntity) {
        context.delete(todo)
        saveContext()
    }
    
    /// Fetches remote to-dos and persists new entries (upsert).
    @MainActor
    func fetchRemoteTodos() async {
        do {
            let remoteTodos = try await remoteTodoFetcher.fetchRemoteTodos()
            for remote in remoteTodos {
                guard !todoExists(withId: Int64(remote.id)) else { continue }
                let todo = ToDoEntity(context: context)
                todo.id = Int64(remote.id)
                todo.title = remote.title
                todo.completed = remote.completed
            }
            saveContext()
        } catch let error as RemoteNetworkError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = RemoteNetworkError.invalidResponse.errorMessage
        }
    }
    
    /// Checks if a to-do with the given ID exists.
    private func todoExists(withId id: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    /// Saves pending changes to Core Data.
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            errorMessage = "We were unable to save your changes. Please try again."
        }
    }
}

