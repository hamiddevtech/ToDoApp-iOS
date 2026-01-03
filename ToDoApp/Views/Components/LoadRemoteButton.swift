//
//  LoadRemoteButton.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 1/2/26.
//

import SwiftUI

/// Button that triggers fetching to-dos from remote server.
struct LoadRemoteButton: View {
    
    // MARK: - Properties
    
    /// Action triggered when button is tapped.
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStrings.loadRemoteTodosButton)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
}
