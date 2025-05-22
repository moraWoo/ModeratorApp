//
//  TooltipView.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI

struct TooltipView: View {
    let message: String
    let buttonTitle: String
    let selectedTab: Int
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Triangle()
                .fill(Color.white)
                .frame(width: 20, height: 10)
                .offset(x: selectedTab == 0 ? 80 : 50)
            
            VStack(spacing: 16) {
                Image(Asset.hand.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                
                Text(message)
                    .font(.system(size: 19))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Button(action: onButtonTap) {
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 110, height: 40)
                        .background(Color.bluePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
            .frame(width: 230, height: 147)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct TooltipOverlay: View {
    let showTooltip: Bool
    let selectedTab: Int
    let onTooltipButtonTap: () -> Void
    
    var body: some View {
        if showTooltip {
            ZStack {
                Color.black.opacity(0.2)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        onTooltipButtonTap()
                    }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        TooltipView(
                            message: selectedTab == 0 ? "Tap to go to Admins" : "Tap to go to All Users",
                            buttonTitle: "Ok!",
                            selectedTab: selectedTab,
                            onButtonTap: onTooltipButtonTap
                        )
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
            }
            .zIndex(100)
        }
    }
}
