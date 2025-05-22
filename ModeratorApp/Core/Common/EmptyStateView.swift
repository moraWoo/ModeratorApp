//
//  EmptyStateView.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(Asset.emptyUsersIcon.name)
                .frame(width: 56, height: 56)
            
            Text("No Users")
                .font(.system(size: 29, weight: .bold))
                .multilineTextAlignment(.center)
            Text("All added users will be displayed here.")
                .font(.headline)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.grayPrimary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
