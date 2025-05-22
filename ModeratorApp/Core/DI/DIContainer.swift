//
//  DIContainer.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import Swinject
import SwiftData

class DIContainer {
    static let shared = DIContainer()
    
    let container = Container()
    
    private init() {
        registerNetworking()
        registerRepositories()
        registerServices()
        registerViewModels()
    }
    
    private func registerNetworking() {
        container.register(NetworkProviderProtocol.self) { _ in
            NetworkProvider()
        }.inObjectScope(.container)
    }
    
    private func registerRepositories() {
        container.register(UserRepositoryProtocol.self) { resolver in
            UserRepositoryFactory(networkProvider: resolver.resolve(NetworkProviderProtocol.self)!)
        }.inObjectScope(.container)
    }
    
    private func registerServices() {
        container.register(UserServiceProtocol.self) { resolver in
            UserService(userRepository: resolver.resolve(UserRepositoryProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(ImageServiceProtocol.self) { _ in
            ImageService()
        }.inObjectScope(.container)
    }
    
    private func registerViewModels() {
        container.register(UserListViewModel.self) { resolver in
            UserListViewModel(userService: resolver.resolve(UserServiceProtocol.self)!)
        }
        
        container.register(UserDetailViewModel.self) { (resolver, user: User) in
            UserDetailViewModel(
                user: user,
                userService: resolver.resolve(UserServiceProtocol.self)!,
                imageService: resolver.resolve(ImageServiceProtocol.self)!
            )
        }
    }
}
