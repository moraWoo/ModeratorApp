//
//  UserSearchView.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI

struct UserSearchView: View {
    @Binding var searchText: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(Asset.searchIcon.name)
                .foregroundColor(Color.grayTetriary)
            
            TextField(placeholder, text: $searchText)
                .foregroundColor(.primary)
                .focused($isFocused)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(Asset.closeButton.name)
                        .foregroundColor(Color.grayTetriary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(12)
        .frame(height: 40)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(isFocused ? Color.bluePrimary : Color.grayTetriary, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}
