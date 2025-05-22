//
//  UserListCoordinator.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI
import Swinject

class UserListCoordinator: Coordinator {
    @Published var currentView: AnyView
    
    private weak var appCoordinator: AppCoordinator?
    private let container: Resolver
    private var userDetailCoordinator: UserDetailCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        self.container = DIContainer.shared.container
        self.currentView = AnyView(EmptyView())
        showUserList()
    }
    
    private func showUserList() {
        let viewModel = container.resolve(UserListViewModel.self)!
        viewModel.coordinator = self
        
        let userListView = UserListView(viewModel: viewModel)
        currentView = AnyView(userListView)
    }
    
    func showUserDetail(user: User) {
        userDetailCoordinator = UserDetailCoordinator(user: user, parentCoordinator: self)
        currentView = AnyView(
            NavigationView {
                userDetailCoordinator!.currentView
            }
        )
    }
    
    func returnToUserList() {
        userDetailCoordinator = nil
        showUserList()
    }
}
