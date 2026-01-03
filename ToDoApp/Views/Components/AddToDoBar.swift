//
//  AddToDoBar.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 1/2/26.
//

import SwiftUI

/// Input bar for creating new to-do items.
struct AddToDoBar: View {
    
    // MARK: - Properties
    
    /// Binding to the new to-do title.
    @Binding var title: String
    
    /// Binding to the completion status toggle.
    @Binding var isCompleted: Bool
    
    /// Action triggered when add button is tapped.
    let onAdd: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            inputField
            completionToggle
            addButton
        }
        .padding()
        .background(.ultraThinMaterial)
        .overlay(topBorder)
    }
    
    // MARK: - Subviews
    
    /// Text field for entering to-do title.
    private var inputField: some View {
        HStack(spacing: 8) {
            Image(systemName: "square.and.pencil")
                .foregroundStyle(.secondary)
            TextField(LocalizedStrings.newTodoPlaceholder, text: $title)
                .textFieldStyle(.plain)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    /// Toggle for marking new to-do as complete.
    private var completionToggle: some View {
        Toggle(isOn: $isCompleted) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isCompleted ? .green : .secondary)
        }
        .toggleStyle(.switch)
    }
    
    /// Button to submit the new to-do.
    private var addButton: some View {
        Button(action: onAdd) {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                Text(LocalizedStrings.addButton)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.accentColor))
            .foregroundStyle(.white)
        }
    }
    
    /// Top border separator line.
    private var topBorder: some View {
        Rectangle()
            .fill(Color.black.opacity(0.08))
            .frame(height: 0.5)
            .frame(maxHeight: .infinity, alignment: .top)
    }
}
