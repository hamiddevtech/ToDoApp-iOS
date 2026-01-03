//
//  TestPersistenceController.swift
//  ToDoAppTests
//
//  Created by Hamid Mahmood on 12/31/25.
//

import CoreData
import XCTest
@testable import ToDoApp

/// In-memory Core Data controller for unit tests.
final class TestPersistenceController {
    
    // MARK: - Properties
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Initialization
    
    init() {
        container = NSPersistentContainer(name: "ToDoApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error {
                XCTFail("Core Data initialization failed: \(error)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
