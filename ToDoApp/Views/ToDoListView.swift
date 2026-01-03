//  ToDoListView.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/31/25.
//

import SwiftUI
import CoreData

/// The main view for displaying and managing to-do items.
///
/// Follows MVVM pattern—reads data via `@FetchRequest` and delegates
/// mutations to ``ToDoListViewModel``.
struct ToDoListView: View {
    
    // MARK: - Properties
    
    /// The view model handling business logic.
    @ObservedObject var viewModel: ToDoListViewModel
    
    /// Fetches persisted to-dos sorted by descending `id`.
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ToDoEntity.id, ascending: false)
        ],
        animation: .default
    )
    private var todos: FetchedResults<ToDoEntity>
    
    /// User input for new to-do title.
    @State private var newTodoTitle = ""
    
    /// User input for new to-do completion status.
    @State private var newTodoCompleted = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LoadRemoteButton {
                    Task { await viewModel.fetchRemoteTodos() }
                }
                .padding(.vertical, 8)
                .padding(.bottom, 10)
                
                SectionHeader(title: LocalizedStrings.todoSectionHeader)
                
                todoList
            }
            .navigationTitle(LocalizedStrings.todoListTitle)
            .safeAreaInset(edge: .bottom) {
                AddToDoBar(
                    title: $newTodoTitle,
                    isCompleted: $newTodoCompleted,
                    onAdd: addTodo
                )
            }
        }
    }
    
    // MARK: - Subviews
    
    private var todoList: some View {
        List {
            ForEach(todos) { todo in
                ToDoRowView(
                    title: todo.title ?? LocalizedStrings.emptyTodoTitle,
                    id: todo.id,
                    isCompleted: todo.completed
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete(perform: deleteTodos)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Actions
    
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        viewModel.addTodo(title: newTodoTitle, status: newTodoCompleted)
        newTodoTitle = ""
        newTodoCompleted = false
    }
    
    private func deleteTodos(at offsets: IndexSet) {
        offsets
            .map { todos[$0] }
            .forEach { viewModel.deleteTodo($0) }
    }
}

