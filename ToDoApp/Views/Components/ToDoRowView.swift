//
//  ToDoRowView.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 1/2/26.
//

import SwiftUI

/// Displays a single to-do item in a list row.
struct ToDoRowView: View {
    
    // MARK: - Properties
    
    /// The to-do item's title.
    let title: String
    
    /// The to-do item's unique identifier.
    let id: Int64
    
    /// Whether the to-do is completed.
    let isCompleted: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            statusIcon
            titleSection
            Spacer()
            statusBadge
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    // MARK: - Subviews
    
    /// Checkmark or circle icon based on completion status.
    private var statusIcon: some View {
        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isCompleted ? .green : .gray)
            .imageScale(.large)
    }
    
    /// Title and ID labels.
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text("#\(id)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    /// Completed/Pending status badge.
    private var statusBadge: some View {
        Text(isCompleted ? LocalizedStrings.completed : LocalizedStrings.pending)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(isCompleted ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
            )
            .foregroundStyle(isCompleted ? .green : .orange)
    }
}
