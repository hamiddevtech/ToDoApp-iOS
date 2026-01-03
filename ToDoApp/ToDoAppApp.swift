//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/30/25.
//

import SwiftUI

/// The main entry point of the application.
///
/// Acts as the composition root where Core Data stack and view models
/// are created and injected into the view hierarchy.
@main
struct ToDoAppApp: App {
    
    // MARK: - Dependencies
    
    /// Core Data persistence controller.
    private let persistenceController: PersistenceController
    
    /// View model for the to-do list.
    @StateObject private var viewModel: ToDoListViewModel
    
    // MARK: - Initialization
    
    init() {
        let controller = PersistenceController()
        self.persistenceController = controller
        _viewModel = StateObject(
            wrappedValue: ToDoListViewModel(context: controller.viewContext)
        )
    }
    
    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            ToDoListView(viewModel: viewModel)
                .environment(
                    \.managedObjectContext,
                     persistenceController.viewContext
                )
        }
    }
}
