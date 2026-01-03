//
//  LocalizedStrings.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 1/1/26.
//

import Foundation

/// Type-safe access to localized strings.
///
/// Provides compile-time checked, autocomplete-friendly string keys
/// for all user-facing text in the app.
enum LocalizedStrings {
    
    // MARK: - Private Helpers
    
    /// Returns localized string for the given key.
    private static func value(
        _ key: String,
        comment: String = ""
    ) -> String {
        NSLocalizedString(key, comment: comment)
    }
}

// MARK: - Navigation

extension LocalizedStrings {
    
    /// Navigation title for the to-do list screen.
    static let todoListTitle = value("todo_list_title")
    
    /// Section header above the to-do list.
    static let todoSectionHeader = value("todo_list_section_header")
}

// MARK: - Buttons

extension LocalizedStrings {
    
    /// Button to fetch to-dos from remote server.
    static let loadRemoteTodosButton = value("todo_button_load_remote")
    
    /// Button to add a new to-do.
    static let addButton = value("todo_button_add")
}

// MARK: - Input

extension LocalizedStrings {
    
    /// Placeholder for new to-do text field.
    static let newTodoPlaceholder = value("todo_input_placeholder")
}

// MARK: - Status Labels

extension LocalizedStrings {
    
    /// Status label for completed to-dos.
    static let completed = value("todo_status_completed")
    
    /// Status label for pending to-dos.
    static let pending = value("todo_status_pending")
}

// MARK: - Fallbacks

extension LocalizedStrings {
    
    /// Fallback when to-do has no title.
    static let emptyTodoTitle = value("todo_fallback_empty_title")
}
