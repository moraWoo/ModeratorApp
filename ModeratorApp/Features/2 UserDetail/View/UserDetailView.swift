//
//  UserDetailView.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI
import PhotosUI

struct UserDetailView: View {
    @ObservedObject var viewModel: UserDetailViewModel
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.graySecondary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button(action: {
                            viewModel.goBack()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                    
                    Text("Detailed Info")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            PhotosPicker(
                                selection: $selectedPhotoItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                ZStack {
                                    if let avatarData = viewModel.user.avatarData, let uiImage = UIImage(data: avatarData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 72, height: 72)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                            .frame(width: 72, height: 72)
                                            .overlay(
                                                Image(Asset.adminsUnactive.name)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 24, height: 24)
                                            )
                                    }
                                    
                                    Image(Asset.add.name)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .offset(x: 36, y: 36)
                                }
                            }
                            .onChange(of: selectedPhotoItem) { newItem in
                                Task {
                                    if let newItem = newItem {
                                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                                            viewModel.updateAvatar(data: data)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("General Info")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.top, 16)
                                .padding(.bottom, 4)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                infoRow(title: "Name:", value: viewModel.user.name)
                                dashedDivider()
                                infoRow(title: "Username:", value: viewModel.user.username)
                                dashedDivider()
                                infoRow(title: "Email:", value: viewModel.user.email)
                                dashedDivider()
                                infoRow(title: "Phone:", value: viewModel.user.phone)
                            }
                        }
                        .frame(height: 311)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.grayTetriary, lineWidth: 0.5)
                        )
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.toggleBanned()
                        }) {
                            HStack(spacing: 8) {
                                Image(Asset.userBlock.name)
                                    .frame(width: 24, height: 24)
                                Text(viewModel.user.isBanned ? "Unblock" : "Block")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.redPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.redSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                        
                        Button(action: {
                            viewModel.toggleAdmin()
                        }) {
                            HStack(spacing: 8) {
                                Image(Asset.addUser.name)
                                    .frame(width: 24, height: 24)
                                Text(viewModel.user.isAdmin ? "Unadmin" : "Assign Admin")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.bluePrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blueSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .frame(height: 80)
                .background(Color.white)
                .overlay(
                    VStack {
                        Rectangle()
                            .fill(Color.grayTetriary)
                            .frame(height: 0.5)
                        Spacer()
                    }
                )
            }
        }
        .navigationBarHidden(true)
    }
    
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.graySecondaryTwo)
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private func dashedDivider() -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 1000, y: 0))
        }
        .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [5]))
        .foregroundColor(.grayTetriary)
        .frame(height: 0.5)
        .padding(.horizontal, 16)
    }
}
