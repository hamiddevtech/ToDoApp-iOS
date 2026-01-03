//
//  TodoRemote.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/31/25.
//

/// A data transfer object representing a to-do item received from a remote API.
///
/// `RemoteTodo` mirrors the JSON structure returned by the backend service
/// and is used exclusively for **network transport and decoding**.
///
/// This type should not contain business logic or persistence concerns.
/// It is intentionally kept lightweight and immutable.
struct RemoteTodo: Decodable {
    
    /// The identifier of the user who owns the to-do item.
    ///
    /// This value is provided by the backend and is used for
    /// grouping or filtering to-do items by user.
    let userId: Int
    
    /// The unique identifier of the to-do item.
    ///
    /// This value uniquely identifies the to-do in the remote system
    /// and is typically used as a stable reference when persisting
    /// or deduplicating records locally.
    let id: Int
    
    /// The human-readable title of the to-do item.
    ///
    /// This is the primary text displayed in the user interface.
    let title: String
    
    /// A Boolean value indicating whether the to-do item is completed.
    ///
    /// - `true`: The to-do has been completed.
    /// - `false`: The to-do is still pending.
    let completed: Bool
}
