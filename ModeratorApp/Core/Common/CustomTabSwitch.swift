//
//  CustomTabSwitch.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI

struct CustomTabSwitch: View {
    @Binding var selection: Int
    var showTooltip: Bool = false
    var tooltipMessage: String = ""
    var tooltipButtonTitle: String = ""
    var onTooltipButtonTap: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 0) {
                ZStack {
                    if selection == 0 {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.white)
                            .frame(width: 44, height: 36)
                    }
                    
                    Image(selection == 0 ? Asset.allUsersActive.name : Asset.allUsersUnactive.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .frame(width: 46, height: 40)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selection = 0
                    }
                }
                
                ZStack {
                    if selection == 1 {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.white)
                            .frame(width: 44, height: 36)
                    }
                    
                    Image(selection == 1 ? Asset.adminsActive.name : Asset.adminsUnactive.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .frame(width: 46, height: 40)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selection = 1
                    }
                }
            }
            .frame(width: 92, height: 40)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 100))
            .padding(.horizontal)
        }
    }
}
