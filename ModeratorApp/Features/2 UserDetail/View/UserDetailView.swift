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
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Button(action: {
                        viewModel.goBack()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                Text("Детальная информация")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    AvatarView(imageData: viewModel.user.avatarData, size: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                        )
                        .overlay(
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .offset(x: -10, y: -10)
                                }
                            }
                        )
                        .padding()
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
                
                if viewModel.user.avatarData != nil {
                    Button("Удалить аватар") {
                        showDeleteAlert = true
                    }
                    .foregroundColor(.red)
                    .font(.caption)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    detailSection(title: "Основная информация") {
                        detailRow(icon: "person.fill", title: "Имя", value: viewModel.user.name)
                        detailRow(icon: "at", title: "Имя пользователя", value: viewModel.user.username)
                        detailRow(icon: "envelope.fill", title: "Email", value: viewModel.user.email)
                        detailRow(icon: "phone.fill", title: "Телефон", value: viewModel.user.phone)
                        detailRow(icon: "globe", title: "Веб-сайт", value: viewModel.user.website)
                    }
                    
                    if let address = viewModel.user.address {
                        detailSection(title: "Адрес") {
                            detailRow(icon: "mappin.and.ellipse", title: "Улица", value: address.street)
                            detailRow(icon: "building.2.fill", title: "Квартира", value: address.suite)
                            detailRow(icon: "building.columns.fill", title: "Город", value: address.city)
                            detailRow(icon: "envelope.fill", title: "Индекс", value: address.zipcode)
                            if let geo = address.geo {
                                detailRow(icon: "location.fill", title: "Координаты", value: "\(geo.lat), \(geo.lng)")
                            }
                        }
                    }
                    
                    if let company = viewModel.user.company {
                        detailSection(title: "Компания") {
                            detailRow(icon: "building.fill", title: "Название", value: company.name)
                            detailRow(icon: "quote.bubble.fill", title: "Слоган", value: company.catchPhrase)
                            detailRow(icon: "briefcase.fill", title: "Сфера", value: company.bs)
                        }
                    }
                    
                    detailSection(title: "Статус пользователя") {
                        Toggle(isOn: .init(
                            get: { viewModel.user.isAdmin },
                            set: { _ in viewModel.toggleAdmin() }
                        )) {
                            HStack {
                                Image(systemName: "shield.fill")
                                    .foregroundColor(.blue)
                                Text("Администратор")
                                    .font(.headline)
                            }
                        }
                        .tint(.blue)
                        
                        Toggle(isOn: .init(
                            get: { viewModel.user.isBanned },
                            set: { _ in viewModel.toggleBanned() }
                        )) {
                            HStack {
                                Image(systemName: "person.fill.xmark")
                                    .foregroundColor(.red)
                                Text("Заблокирован")
                                    .font(.headline)
                            }
                        }
                        .tint(.red)
                    }
                }
                .padding()
            }
        }
        .alert("Удалить аватар", isPresented: $showDeleteAlert) {
            Button("Удалить", role: .destructive) {
                viewModel.deleteAvatar()
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Вы уверены, что хотите удалить аватар?")
        }
    }
    
    private func detailSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            content()
        }
        .padding(.vertical, 8)
    }
    
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
