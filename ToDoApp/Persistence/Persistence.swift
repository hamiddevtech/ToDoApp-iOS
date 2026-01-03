//
//  Persistence.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/30/25.
//

import CoreData

/// Manages the Core Data stack for the application.
struct PersistenceController {
    
    // MARK: - Properties
    
    /// The Core Data persistent container.
    let container: NSPersistentContainer
    
    /// The main view context for persistence operations.
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Initialization
    
    /// Creates a persistence controller.
    ///
    /// - Parameter inMemory: If `true`, uses an in-memory store for testing.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoApp")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url =
            URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
