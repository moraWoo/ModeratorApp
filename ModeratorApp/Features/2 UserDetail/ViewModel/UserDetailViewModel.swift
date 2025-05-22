//
//  UserDetailViewModel.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class UserDetailViewModel: ObservableObject {
    @Published var user: User
    
    private let userService: UserServiceProtocol
    private let imageService: ImageServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: UserDetailCoordinator?
    
    init(user: User, userService: UserServiceProtocol, imageService: ImageServiceProtocol) {
        self.user = user
        self.userService = userService
        self.imageService = imageService
    }
    
    func toggleAdmin() {
        user.isAdmin.toggle()
        userService.updateUserStatus(userId: user.id, isAdmin: user.isAdmin, isBanned: nil)
    }
    
    func toggleBanned() {
        user.isBanned.toggle()
        userService.updateUserStatus(userId: user.id, isAdmin: nil, isBanned: user.isBanned)
    }
    
    func updateAvatar(data: Data) {
        user.avatarData = data
        userService.updateUserAvatar(userId: user.id, imageData: data)
    }
    
    func deleteAvatar() {
        user.avatarData = nil
        userService.updateUserAvatar(userId: user.id, imageData: nil)
    }
    
    func goBack() {
        coordinator?.dismiss()
    }
}
