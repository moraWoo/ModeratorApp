//
//  UserDetailCoordinator.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI
import Swinject

class UserDetailCoordinator: Coordinator {
    @Published var currentView: AnyView
    
    private weak var parentCoordinator: UserListCoordinator?
    private let container: Resolver
    private let user: User
    
    init(user: User, parentCoordinator: UserListCoordinator) {
        self.user = user
        self.parentCoordinator = parentCoordinator
        self.container = DIContainer.shared.container
        self.currentView = AnyView(EmptyView())
        showUserDetail()
    }
    
    private func showUserDetail() {
        let viewModel = container.resolve(UserDetailViewModel.self, argument: user)!
        viewModel.coordinator = self
        
        let userDetailView = UserDetailView(viewModel: viewModel)
        currentView = AnyView(userDetailView)
    }
    
    func dismiss() {
        parentCoordinator?.returnToUserList()
    }
}
