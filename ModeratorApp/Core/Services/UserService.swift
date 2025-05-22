//
//  UserService.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import Combine

protocol UserServiceProtocol {
    var userRepository: UserRepositoryProtocol { get }
    func fetchUsers() -> AnyPublisher<[User], Error>
    func getUsers(adminOnly: Bool, searchText: String) -> [User]
    func updateUserStatus(userId: Int, isAdmin: Bool?, isBanned: Bool?)
    func updateUserAvatar(userId: Int, imageData: Data?)
}

class UserService: UserServiceProtocol {
    let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func fetchUsers() -> AnyPublisher<[User], Error> {
        return userRepository.fetchUsers()
    }
    
    func getUsers(adminOnly: Bool, searchText: String) -> [User] {
        return userRepository.getUsers(adminOnly: adminOnly, searchText: searchText)
    }
    
    func updateUserStatus(userId: Int, isAdmin: Bool?, isBanned: Bool?) {
        userRepository.updateUserStatus(userId: userId, isAdmin: isAdmin, isBanned: isBanned)
    }
    
    func updateUserAvatar(userId: Int, imageData: Data?) {
        userRepository.updateUserAvatar(userId: userId, imageData: imageData)
    }
}
