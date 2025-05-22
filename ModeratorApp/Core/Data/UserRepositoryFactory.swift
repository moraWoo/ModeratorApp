//
//  UserRepositoryFactory.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

    // UserRepositoryFactory.swift - финальная простая версия
import CombineMoya
import Combine
import Foundation
import Moya
import SwiftData

class UserRepositoryFactory: UserRepositoryProtocol {
    private var repository: UserRepository?
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    func setModelContainer(_ container: ModelContainer) {
        DispatchQueue.main.async {
            self.repository = UserRepository(
                networkProvider: self.networkProvider,
                modelContainer: container
            )
        }
    }

    func fetchUsers() -> AnyPublisher<[User], Error> {
        guard let repository = repository else {
            return Fail(error: NSError(domain: "Repository not initialized", code: -1))
                .eraseToAnyPublisher()
        }
        return repository.fetchUsers()
    }
    
    func getUsers(adminOnly: Bool, searchText: String) -> [User] {
        guard let repository = repository else { return [] }
        
        if Thread.isMainThread {
            return repository.getUsers(adminOnly: adminOnly, searchText: searchText)
        } else {
            return DispatchQueue.main.sync {
                return repository.getUsers(adminOnly: adminOnly, searchText: searchText)
            }
        }
    }
    
    func updateUserStatus(userId: Int, isAdmin: Bool?, isBanned: Bool?) {
        guard let repository = repository else { return }
        
        if Thread.isMainThread {
            repository.updateUserStatus(userId: userId, isAdmin: isAdmin, isBanned: isBanned)
        } else {
            DispatchQueue.main.async {
                repository.updateUserStatus(userId: userId, isAdmin: isAdmin, isBanned: isBanned)
            }
        }
    }
    
    func updateUserAvatar(userId: Int, imageData: Data?) {
        guard let repository = repository else { return }
        
        if Thread.isMainThread {
            repository.updateUserAvatar(userId: userId, imageData: imageData)
        } else {
            DispatchQueue.main.async {
                repository.updateUserAvatar(userId: userId, imageData: imageData)
            }
        }
    }
}
