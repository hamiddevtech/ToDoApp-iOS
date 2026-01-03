//
//  SectionHeader.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 1/2/26.
//

import SwiftUI

/// Displays a styled section header.
struct SectionHeader: View {
    
    // MARK: - Properties
    
    /// The header title text.
    let title: String
    
    // MARK: - Body
    
    var body: some View {
        Text(title)
            .font(.title3.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .foregroundStyle(.secondary)
    }
}
