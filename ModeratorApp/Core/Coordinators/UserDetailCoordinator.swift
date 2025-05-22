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
    private var appCoordinator: AppCoordinator?
    private let container: Resolver
    private let user: User
    
    init(user: User, parentCoordinator: AppCoordinator) {
        self.appCoordinator = parentCoordinator
        self.user = user
        self.container = DIContainer.shared.container
        self.currentView = AnyView(EmptyView())
        showUserDetail()
    }
    
    private func showUserDetail() {
        let viewModel = container.resolve(UserDetailViewModel.self, argument: user)!
        viewModel.coordinator = self
        print("Coordinator set: \(viewModel.coordinator != nil)")
        
        let userDetailView = UserDetailView(viewModel: viewModel)
        currentView = AnyView(userDetailView)
    }
    
    func dismiss() {
        appCoordinator?.returnToUserList()
    }
}
