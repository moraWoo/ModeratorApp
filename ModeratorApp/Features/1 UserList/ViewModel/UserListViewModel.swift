//
//  UserListViewModel.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var selectedTab: Int = 0
    @Published var searchText: String = ""
    @Published var showAllUsersTooltip: Bool = false
    @Published var showAdminsTooltip: Bool = false
    
    private let userService: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: UserListCoordinator?
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        
        self.showAllUsersTooltip = !UserDefaults.standard.bool(forKey: "allUsersTooltipShown")
        self.showAdminsTooltip = !UserDefaults.standard.bool(forKey: "adminsTooltipShown")
        
        $selectedTab
            .combineLatest($searchText)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.loadLocalUsers()
            }
            .store(in: &cancellables)
    }
    
    func initializeWithModelContext(_ modelContext: ModelContext) {
        if let repositoryFactory = userService.userRepository as? UserRepositoryFactory {
            repositoryFactory.setModelContainer(modelContext.container)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.refreshUsers()
            }
        }
    }
    
    func loadLocalUsers() {
        users = userService.getUsers(adminOnly: selectedTab == 1, searchText: searchText)
    }
    
    func refreshUsers() {
        isLoading = true
        
        userService.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("Error fetching users: \(error)")
                    }
                    self?.loadLocalUsers()
                },
                receiveValue: { [weak self] _ in
                    // TODO: -
                }
            )
            .store(in: &cancellables)
    }
    
    func onUserTapped(user: User) {
        print("User tapped: \(user.name)")
        coordinator?.showUserDetail(user: user)
    }
    
    func toggleAdmin(for user: User) {
        userService.updateUserStatus(userId: user.id, isAdmin: !user.isAdmin, isBanned: nil)
        loadLocalUsers()
    }
    
    func toggleBanned(for user: User) {
        userService.updateUserStatus(userId: user.id, isAdmin: nil, isBanned: !user.isBanned)
        loadLocalUsers()
    }
    
    func markAllUsersTooltipAsShown() {
        showAllUsersTooltip = false
        UserDefaults.standard.set(true, forKey: "allUsersTooltipShown")
    }
    
    func markAdminsTooltipAsShown() {
        showAdminsTooltip = false
        UserDefaults.standard.set(true, forKey: "adminsTooltipShown")
    }
}
