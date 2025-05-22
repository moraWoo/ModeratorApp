//
//  UserRepository.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import Combine
import SwiftData

protocol UserRepositoryProtocol {
    func fetchUsers() -> AnyPublisher<[User], Error>
    func getUsers(adminOnly: Bool, searchText: String) -> [User]
    func updateUserStatus(userId: Int, isAdmin: Bool?, isBanned: Bool?)
    func updateUserAvatar(userId: Int, imageData: Data?)
}

class UserRepository: UserRepositoryProtocol {
    private let networkProvider: NetworkProviderProtocol
    private let modelContext: ModelContext
    
    @MainActor
    init(networkProvider: NetworkProviderProtocol, modelContainer: ModelContainer) {
        self.networkProvider = networkProvider
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchUsers() -> AnyPublisher<[User], Error> {
        return networkProvider.request(.getUsers, type: [UserRequest].self)
            .receive(on: DispatchQueue.main)
            .map { [weak self] dtos -> [User] in
                guard let self = self else { return [] }
                return self.synchronizeUsers(dtos: dtos)
            }
            .eraseToAnyPublisher()
    }

    private func synchronizeUsers(dtos: [UserRequest]) -> [User] {
        dispatchPrecondition(condition: .onQueue(.main))
        
        var resultUsers: [User] = []
        
        for dto in dtos {
            let userId = dto.id
            let descriptor = FetchDescriptor<User>(predicate: #Predicate { user in
                user.id == userId
            })
            
            do {
                let existingUsers = try modelContext.fetch(descriptor)
                let user: User
                
                if let existingUser = existingUsers.first {
                    user = existingUser
                    user.name = dto.name
                    user.username = dto.username
                    user.email = dto.email
                    user.phone = dto.phone
                    user.website = dto.website
                    
                    if let existingAddress = user.address {
                        existingAddress.street = dto.address.street
                        existingAddress.suite = dto.address.suite
                        existingAddress.city = dto.address.city
                        existingAddress.zipcode = dto.address.zipcode
                        
                        if let existingGeo = existingAddress.geo {
                            existingGeo.lat = dto.address.geo.lat
                            existingGeo.lng = dto.address.geo.lng
                        } else {
                            existingAddress.geo = Geo(lat: dto.address.geo.lat, lng: dto.address.geo.lng)
                        }
                    } else {
                        let geo = Geo(lat: dto.address.geo.lat, lng: dto.address.geo.lng)
                        user.address = Address(
                            street: dto.address.street,
                            suite: dto.address.suite,
                            city: dto.address.city,
                            zipcode: dto.address.zipcode,
                            geo: geo
                        )
                    }
                    
                    if let existingCompany = user.company {
                        existingCompany.name = dto.company.name
                        existingCompany.catchPhrase = dto.company.catchPhrase
                        existingCompany.bs = dto.company.bs
                    } else {
                        user.company = Company(
                            name: dto.company.name,
                            catchPhrase: dto.company.catchPhrase,
                            bs: dto.company.bs
                        )
                    }
                } else {
                    user = User(
                        id: dto.id,
                        name: dto.name,
                        username: dto.username,
                        email: dto.email,
                        phone: dto.phone,
                        website: dto.website
                    )
                    
                    let geo = Geo(lat: dto.address.geo.lat, lng: dto.address.geo.lng)
                    user.address = Address(
                        street: dto.address.street,
                        suite: dto.address.suite,
                        city: dto.address.city,
                        zipcode: dto.address.zipcode,
                        geo: geo
                    )
                    
                    user.company = Company(
                        name: dto.company.name,
                        catchPhrase: dto.company.catchPhrase,
                        bs: dto.company.bs
                    )
                    
                    modelContext.insert(user)
                }
                
                resultUsers.append(user)
            } catch {
                print("Error fetching or saving user: \(error)")
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        return resultUsers
    }

    func getUsers(adminOnly: Bool, searchText: String) -> [User] {
        dispatchPrecondition(condition: .onQueue(.main))
        
        var descriptor = FetchDescriptor<User>()
        
        if adminOnly {
            descriptor.predicate = #Predicate<User> { user in
                !user.isBanned && user.isAdmin == true
            }
        } else {
            descriptor.predicate = #Predicate<User> { user in
                !user.isBanned
            }
        }
        
        descriptor.sortBy = [SortDescriptor(\.name)]
        
        do {
            let users = try modelContext.fetch(descriptor)
            
            if !searchText.isEmpty {
                let searchTextLower = searchText.lowercased()
                return users.filter { user in
                    user.name.lowercased().contains(searchTextLower)
                }
            }
            
            return users
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }
    
    func updateUserStatus(userId: Int, isAdmin: Bool?, isBanned: Bool?) {
        dispatchPrecondition(condition: .onQueue(.main))
        
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == userId })
        
        do {
            let users = try modelContext.fetch(descriptor)
            if let user = users.first {
                if let isAdmin = isAdmin {
                    user.isAdmin = isAdmin
                }
                
                if let isBanned = isBanned {
                    user.isBanned = isBanned
                }
                
                try modelContext.save()
            }
        } catch {
            print("Error updating user status: \(error)")
        }
    }
    
    func updateUserAvatar(userId: Int, imageData: Data?) {
        dispatchPrecondition(condition: .onQueue(.main))
        
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == userId })
        
        do {
            let users = try modelContext.fetch(descriptor)
            if let user = users.first {
                user.avatarData = imageData
                try modelContext.save()
            }
        } catch {
            print("Error updating user avatar: \(error)")
        }
    }
}
