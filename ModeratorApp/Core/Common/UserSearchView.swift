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
    
    var body: some View {
        HStack {
            Image(Asset.searchIcon.name)
                .foregroundColor(Color.grayTetriary)
            
            TextField(placeholder, text: $searchText)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(Asset.closeButton.name)
                        .foregroundColor(Color.grayTetriary)
                }
            }
        }
        .padding(12)
        .frame(height: 40)
        .background(Color.grayTetriary)
        .cornerRadius(100)
    }
}
